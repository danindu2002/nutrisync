package com.y421.nutrisyncservice.request.dietPlan;

import lombok.Builder;
import lombok.Data;
import java.util.List;

@Data
@Builder
public class MealPlanRequestDTO {
    private Integer age;
    private String gender;
    private Float weightKg;
    private Float heightCm;
    private String activityLevel;
    private String fitnessGoal;
    private Integer dailyCalorieGoal;
    private List<String> allergies;
    private List<String> dietaryPreferences;
}