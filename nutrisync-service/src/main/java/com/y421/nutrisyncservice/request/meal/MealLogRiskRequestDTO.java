package com.y421.nutrisyncservice.request.meal;

import com.y421.nutrisyncservice.entity.foodMaster.FoodMaster;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MealLogRiskRequestDTO {

    private Integer predictionPeriod;
    private String gender;
    private int age;
    private double heightCm;
    private double weightKg;
    private double bmi;
    private String activityLevel;
    private String goalSpeed;
    private List<String> dietaryPreferences;
    private MealTimesDTO mealTimes;
    private List<String> allergies;
    private List<String> medicalConditions;
    private int dailyCalorieGoal;
    private String sleepQuality;
    private List<MealLogDTO> mealLogList;
}

