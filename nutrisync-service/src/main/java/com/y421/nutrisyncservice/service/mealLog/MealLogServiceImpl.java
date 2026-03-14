package com.y421.nutrisyncservice.service.mealLog;

import com.y421.nutrisyncservice.entity.foodMaster.FoodMaster;
import com.y421.nutrisyncservice.entity.mealLog.MealLog;
import com.y421.nutrisyncservice.entity.mealLog.MealTime;
import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.mapper.meal.MealMapper;
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
    private final MealMapper mealMapper;
    private final AIServiceClient aiServiceClient;

    @Override
    public ResponseEntity<Object> identifyFood(MultipartFile image) {
        try {
            String label = aiServiceClient.predictFood(image);

            // Find the first matching entry from USDA data
            Optional<FoodMaster> food = foodRepository.searchByLabel(label).stream().findFirst();
            if (food.isEmpty()) {
                return new ResponseEntity<>("Food not found in database", HttpStatus.NOT_FOUND);
            }

            FoodIdentificationDTO dto = mealMapper.toFoodIdentificationDTO(food.get());
            dto.setName(label); // Override with AI label for better user experience

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
            Optional<NutrisyncUser> user = userRepository.findById(dto.getUserId());
            if (user.isEmpty()) {
                return new ResponseEntity<>("User not found", HttpStatus.NOT_FOUND);
            }
            FoodMaster foodToLog;
            float factor = dto.getWeight() / 100.0f;

            if (dto.getFoodId() != null) {
                // Existing Food
                Optional<FoodMaster> foodOpt = foodRepository.findById(dto.getFoodId());
                if (foodOpt.isEmpty()) {
                    return new ResponseEntity<>("Food not found", HttpStatus.NOT_FOUND);
                }
                foodToLog = foodOpt.get();
            } else {
                // Manual Entry
                if (dto.getName() == null || dto.getName().trim().isEmpty()) {
                    return new ResponseEntity<>("Food name is required for manual entry", HttpStatus.BAD_REQUEST);
                }

                FoodMaster newFood = new FoodMaster();
                newFood.setName(dto.getName());
                newFood.setIsManual(true);
                newFood.setCategory("MANUAL_ENTRY");

                float calcWeight = (dto.getWeight() != null && dto.getWeight() > 0) ? dto.getWeight() : 100f;
                float reverseFactor = 100.0f / calcWeight;

                if (dto.getTotalCalories() != null) {
                    newFood.setCaloriesInKcal(String.valueOf(dto.getTotalCalories() * reverseFactor));
                } else {
                    newFood.setCaloriesInKcal("0");
                }
                if (dto.getTotalProtein() != null) {
                    newFood.setProteinInG(String.valueOf(dto.getTotalProtein() * reverseFactor));
                } else {
                    newFood.setProteinInG("0");
                }
                if (dto.getTotalCarbs() != null) {
                    newFood.setCarbohydratesInG(String.valueOf(dto.getTotalCarbs() * reverseFactor));
                } else {
                    newFood.setCarbohydratesInG("0");
                }
                foodToLog = foodRepository.save(newFood);
            }

            MealLog log = new MealLog();
            log.setUser(user.get());
            log.setFoodMaster(foodToLog); // Uses either the found food OR the newly created one
            log.setFoodName(dto.getName() != null ? dto.getName() : foodToLog.getName());
            log.setConsumedQuantity(dto.getWeight());

            // Calculate final log macros
            log.setTotalCalories(dto.getTotalCalories() != null ? dto.getTotalCalories() : (parseValue(foodToLog.getCaloriesInKcal()) * factor));
            log.setTotalProtein(dto.getTotalProtein() != null ? dto.getTotalProtein() : (parseValue(foodToLog.getProteinInG()) * factor));
            log.setTotalCarbs(dto.getTotalCarbs() != null ? dto.getTotalCarbs() : (parseValue(foodToLog.getCarbohydratesInG()) * factor));

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

            List<MealLogResponseDTO> dtoList = mealLogRepository.findByUserIdAndDate(userId, date).stream()
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