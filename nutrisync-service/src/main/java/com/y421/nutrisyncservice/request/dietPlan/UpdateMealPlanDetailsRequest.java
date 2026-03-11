package com.y421.nutrisyncservice.request.dietPlan;

import lombok.Data;

@Data
public class UpdateMealPlanDetailsRequest {
    private String dietPlanName;
    private String dietPlanDescription;
    private String dietPlanImage;
}