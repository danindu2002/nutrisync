package com.y421.nutrisyncservice.service.mealLog;

import com.y421.nutrisyncservice.entity.foodMaster.FoodMaster;
import com.y421.nutrisyncservice.entity.mealLog.MealLog;
import com.y421.nutrisyncservice.entity.mealLog.MealTime;
import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.repository.foodMaster.FoodMasterRepository;
import com.y421.nutrisyncservice.repository.mealLog.MealLogRepository;
import com.y421.nutrisyncservice.repository.nutrisyncUser.NutrisyncUserRepository;
import com.y421.nutrisyncservice.request.meal.MealLogRequestDTO;
import com.y421.nutrisyncservice.response.meal.FoodIdentificationDTO;
import com.y421.nutrisyncservice.response.meal.MealLogResponseDTO;
import com.y421.nutrisyncservice.service.ai.AIServiceClient;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MealLogServiceImpl implements MealLogService {

    private final FoodMasterRepository foodRepository;
    private final MealLogRepository mealLogRepository;
    private final NutrisyncUserRepository userRepository;
    private final AIServiceClient aiServiceClient;

    @Override
    public ResponseEntity<Object> identifyFood(MultipartFile image) {
        try {
            String label = aiServiceClient.predictFood(image);

            // Find the first matching entry from USDA data
            FoodMaster food = foodRepository.searchByLabel(label).stream()
                    .findFirst()
                    .orElseThrow(() -> new RuntimeException("Food not recognized in database"));

            FoodIdentificationDTO dto = new FoodIdentificationDTO(
                    food.getFoodId(),
                    food.getName(),
                    food.getCaloriesInKcal(),
                    food.getProteinInG(),
                    food.getCarbohydratesInG(),
                    food.getTotalFatsInG()
            );

            return new ResponseEntity<>(dto, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Error Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    @Transactional
    public ResponseEntity<Object> saveMealLog(MealLogRequestDTO dto, MultipartFile image) throws IOException {
        try {
            Optional<FoodMaster> food = foodRepository.findById(dto.getFoodId());
            if (food.isEmpty()) {
                return new ResponseEntity<>("Food not found", HttpStatus.NOT_FOUND);
            }
            Optional<NutrisyncUser> user = userRepository.findById(dto.getUserId());
            if (user.isEmpty()) {
                return new ResponseEntity<>("User not found", HttpStatus.NOT_FOUND);
            }
            float factor = dto.getWeight() / 100.0f;

            MealLog log = new MealLog();
            log.setUser(user.get());
            log.setFoodMaster(food.get());
            log.setFoodName(dto.getName() != null ? dto.getName() : food.get().getName());
            log.setConsumedQuantity(dto.getWeight());
            log.setTotalCalories(dto.getTotalCalories() != null ? dto.getTotalCalories() : parseValue(food.get().getCaloriesInKcal()) * factor);
            log.setTotalProtein(dto.getTotalProtein() != null ? dto.getTotalProtein() : parseValue(food.get().getProteinInG()) * factor);
            log.setTotalCarbs(dto.getTotalCarbs() != null ? dto.getTotalCarbs() : parseValue(food.get().getCarbohydratesInG()) * factor);
            log.setMealTime(MealTime.valueOf(dto.getMealTime().toUpperCase()));
            log.setSuggestRecommendations(dto.getSuggestRecommendations());
            log.setImage(image != null ? image.getBytes() : null);

            mealLogRepository.save(log);
            return new ResponseEntity<>("Meal log saved successfully", HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Error Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    public ResponseEntity<Object> getDailyLogs(Long userId, LocalDate date) {
        try {
            Optional<NutrisyncUser> user = userRepository.findById(userId);
            if (user.isEmpty()) {
                return new ResponseEntity<>("User not found", HttpStatus.NOT_FOUND);
            }

            List<MealLogResponseDTO> dtoList = foodRepository.findByUserIdAndDate(userId, date).stream()
                    .map(log -> MealLogResponseDTO.builder()
                            .logId(log.getLogId())
                            .foodName(log.getFoodName())
                            .totalCalories(log.getTotalCalories())
                            .totalProtein(log.getTotalProtein())
                            .totalCarbs(log.getTotalCarbs())
                            .mealTime(log.getMealTime().name())
                            .image(log.getImage())
                            .build())
                    .toList();
            return new ResponseEntity<>(dtoList, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Error Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    public ResponseEntity<Object> deleteLog(Long logId) {
        try {
            Optional<MealLog> mealLog = mealLogRepository.findById(logId);
            if (mealLog.isEmpty()) {
                return new ResponseEntity<>("Meal Not Found", HttpStatus.NOT_FOUND);
            }
            mealLog.get().setIsDeleted(true);
            mealLogRepository.save(mealLog.get());
            return new ResponseEntity<>("Log Deleted Successfully", HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Error Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // Helper to extract numeric value from strings like "9.00 mg" or "381"
    private Float parseValue(String value) {
        if (value == null || value.isEmpty()) return 0.0f;
        return Float.parseFloat(value.replaceAll("[^0-9.]", ""));
    }
}