package com.y421.nutrisyncservice.response.meal;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class MealLogResponseDTO {
    private Long logId;
    private String foodName;
    private Float totalCalories;
    private Float totalProtein;
    private Float totalCarbs;
    private Float totalFats;
    private String mealTime;
    private byte[] image;
}