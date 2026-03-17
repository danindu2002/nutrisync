package com.y421.nutrisyncservice.request.dietPlan;

import com.y421.nutrisyncservice.response.dietPlan.MealPlanResponseDTO;
import lombok.Data;

@Data
public class SaveMealPlanRequest {
    private Long userId;
    private String dietPlanName;
    private String dietPlanDescription;
    private String dietPlanImage;
    private MealPlanResponseDTO generatedPlan; // The exact JSON from the AI preview
}