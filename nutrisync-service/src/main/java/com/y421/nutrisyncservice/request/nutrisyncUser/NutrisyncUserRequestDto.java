package com.y421.nutrisyncservice.request.nutrisyncUser;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class NutrisyncUserRequestDto {
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private Date dateOfBirth;
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
    private String fitnessGoal;
    private String goalMotivation;
    private Date regDate;
}
