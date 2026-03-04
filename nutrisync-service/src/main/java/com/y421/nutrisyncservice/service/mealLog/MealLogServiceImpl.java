package com.y421.nutrisyncservice.service.mealLog;

import com.y421.nutrisyncservice.entity.foodMaster.FoodMaster;
import com.y421.nutrisyncservice.entity.mealLog.MealLog;
import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.repository.foodMaster.FoodMasterRepository;
import com.y421.nutrisyncservice.repository.mealLog.MealLogRepository;
import com.y421.nutrisyncservice.repository.nutrisyncUser.NutrisyncUserRepository;
import com.y421.nutrisyncservice.service.ai.AIServiceClient;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
public class MealLogServiceImpl implements MealLogService {

    private final FoodMasterRepository foodRepository;
    private final MealLogRepository mealLogRepository;
    private final NutrisyncUserRepository userRepository;
    private final AIServiceClient aiServiceClient; // External client for your Food-101 model

    @Override
    @Transactional
    public ResponseEntity<Object> identifyAndLogMeal(MultipartFile image, Long userId, String mealType) {
        try {
            // 1. Send image to your AI model
            String foodLabel = aiServiceClient.predictFood(image); // Returns "apple_pie"
            
            // 2. Lookup nutrition from Kaggle-based Master table
            FoodMaster nutrition = foodRepository.findByLabelIgnoreCase(foodLabel)
                    .orElseThrow(() -> new RuntimeException("Food not found in database"));

            // 3. Save to Meal Log
            NutrisyncUser user = userRepository.findById(userId).get();
            MealLog log = new MealLog();
            log.setUser(user);
            log.setIdentifiedFood(foodLabel);
            log.setConsumedCalories(nutrition.getCalories());
            log.setMealType(mealType);
            mealLogRepository.save(log);

            return new ResponseEntity<>(nutrition, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>("Failed to identify meal", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}