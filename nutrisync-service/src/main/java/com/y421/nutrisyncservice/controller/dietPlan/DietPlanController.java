package com.y421.nutrisyncservice.controller.dietPlan;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@RequestMapping("/api/v1/diet-plan")
public interface DietPlanController {

    @PostMapping("/")
    ResponseEntity<Object> createCustomMealPlan(@RequestParam("userId") Long userId);

}
