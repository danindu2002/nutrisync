package com.y421.nutrisyncservice.service.impactSimulator;

import com.y421.nutrisyncservice.request.dietPlan.SaveMealPlanRequest;
import com.y421.nutrisyncservice.request.dietPlan.UpdateMealPlanDetailsRequest;
import org.springframework.http.ResponseEntity;

public interface ImpactSimulatorService {
    ResponseEntity<Object> getUserBMI(Long userId);
    ResponseEntity<Object> simulateImpact(Long userId, Integer months);
}
