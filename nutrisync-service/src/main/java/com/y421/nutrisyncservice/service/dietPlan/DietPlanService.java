package com.y421.nutrisyncservice.service.dietPlan;

import com.y421.nutrisyncservice.request.dietPlan.SaveMealPlanRequest;
import com.y421.nutrisyncservice.request.dietPlan.UpdateMealPlanDetailsRequest;
import org.springframework.http.ResponseEntity;

public interface DietPlanService {
    ResponseEntity<Object> generateMealPlanPreview(Long userId);
    ResponseEntity<Object> saveMealPlan(SaveMealPlanRequest request);
    ResponseEntity<Object> getAllDietPlansByUser(Long userId);
    ResponseEntity<Object> deleteDietPlan(Long planId);
    ResponseEntity<Object> updateDietPlanDetails(Long planId, UpdateMealPlanDetailsRequest request);
    ResponseEntity<Object> getDietPlanDetails(Long planId);
}
