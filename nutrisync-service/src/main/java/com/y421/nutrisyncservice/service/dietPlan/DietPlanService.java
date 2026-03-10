package com.y421.nutrisyncservice.service.dietPlan;

import org.springframework.http.ResponseEntity;

public interface DietPlanService {
    ResponseEntity<Object> createCustomMealPlan(Long userId);
}
