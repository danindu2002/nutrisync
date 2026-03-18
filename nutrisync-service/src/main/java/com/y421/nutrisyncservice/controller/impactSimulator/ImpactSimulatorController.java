package com.y421.nutrisyncservice.controller.impactSimulator;

import com.y421.nutrisyncservice.request.dietPlan.SaveMealPlanRequest;
import com.y421.nutrisyncservice.request.dietPlan.UpdateMealPlanDetailsRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequestMapping("/api/v1/impact-simulator")
public interface ImpactSimulatorController {

    @GetMapping("/userBMI/{userId}")
    ResponseEntity<Object> getUserBMI(@PathVariable("userId") Long userId);

    @GetMapping("/simulateImpact/{userId}")
    ResponseEntity<Object> simulateImpact(@PathVariable("userId") Long userId, @RequestParam("months") Integer months);
}
