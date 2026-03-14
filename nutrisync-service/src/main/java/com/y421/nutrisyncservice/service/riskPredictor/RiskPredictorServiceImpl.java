package com.y421.nutrisyncservice.service.riskPredictor;

import com.y421.nutrisyncservice.entity.mealLog.MealLog;
import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.mapper.meal.MealMapper;
import com.y421.nutrisyncservice.repository.foodMaster.FoodMasterRepository;
import com.y421.nutrisyncservice.repository.mealLog.MealLogRepository;
import com.y421.nutrisyncservice.repository.nutrisyncUser.NutrisyncUserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class RiskPredictorServiceImpl implements RiskPredictorService {

    private final FoodMasterRepository foodRepository;
    private final MealLogRepository mealLogRepository;
    private final NutrisyncUserRepository userRepository;
    private final MealMapper mealMapper;

    @Override
    public ResponseEntity<Object> predictRisk(Long userId) {
        try {
            Optional<NutrisyncUser> user = userRepository.findByUserIdAndIsDeletedFalse(userId);
            if (user.isEmpty()) {
                return new ResponseEntity<>("User Not Found", HttpStatus.NOT_FOUND);
            }
            List<MealLog> mealLog = mealLogRepository.findByUserAndIsDeletedFalse(user.get());
            if (mealLog.isEmpty()) {
                return new ResponseEntity<>("Meal Logs Not Found", HttpStatus.NOT_FOUND);
            }

            return new ResponseEntity<>("Risk Predicted Successfully", HttpStatus.OK);
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