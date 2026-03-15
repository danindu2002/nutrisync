package com.y421.nutrisyncservice.request.riskPredictor;

import com.y421.nutrisyncservice.entity.mealLog.MealLog;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;
import java.util.Map;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class RiskPredictorRequestDTO {
    private String gender;
    private Integer age;
    private Float heightCm;
    private Float weightKg;
    private Float bmi;
    private String activityLevel;
    private String goalSpeed;
    private List<String> dietaryPreferences;
    private Map<String, String> mealTimes;
    private List<String> allergies;
    private List<String> medicalConditions;
    private Integer dailyCalorieGoal;
    private String sleepQuality;
    private List<MealLog> mealLogList;
}