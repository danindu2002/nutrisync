package com.y421.nutrisyncservice.controller.dietPlan;

import com.y421.nutrisyncservice.request.dietPlan.SaveMealPlanRequest;
import com.y421.nutrisyncservice.request.dietPlan.UpdateMealPlanDetailsRequest;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequestMapping("/api/v1/diet-plan")
public interface DietPlanController {

    @PostMapping("/preview")
    ResponseEntity<Object> generateMealPlanPreview(@RequestParam("userId") Long userId);

    @PostMapping("/save")
    ResponseEntity<Object> saveMealPlan(@RequestBody SaveMealPlanRequest request);

    @GetMapping("/user/{userId}")
    ResponseEntity<Object> getAllDietPlansByUser(@PathVariable("userId") Long userId);

    @DeleteMapping("/{planId}")
    ResponseEntity<Object> deleteDietPlan(@PathVariable("planId") Long planId);

    @PutMapping("/{planId}")
    ResponseEntity<Object> updateDietPlanDetails(@PathVariable("planId") Long planId, @RequestBody UpdateMealPlanDetailsRequest request);

    @GetMapping("/{planId}")
    ResponseEntity<Object> getDietPlanDetails(@PathVariable("planId") Long planId);
}
