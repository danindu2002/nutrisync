package com.y421.nutrisyncservice.request.meal;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MealLogRequestDTO {
    private Long userId;
    private Long foodId;
    private Float weight; // in grams
    private String mealTime; // BREAKFAST, LUNCH, etc.
    private String notes;
    private Boolean suggestRecommendations;

    // for manually entered food items
    private String name;
    private Float totalProtein;
    private Float totalCarbs;
    private Float totalCalories;
}