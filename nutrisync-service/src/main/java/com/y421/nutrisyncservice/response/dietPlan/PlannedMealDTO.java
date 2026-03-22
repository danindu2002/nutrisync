package com.y421.nutrisyncservice.response.dietPlan;

import lombok.Data;

@Data
public class PlannedMealDTO {
    private Long mealId;
    private String mealType;
    private String recipeName;
    private String imageSearchTerm;
    private Integer prepTimeMin;
    private Integer calories;
    private Integer proteinG;
    private Integer carbsG;
    private Integer fatG;
    private String mealImageUrl;
}