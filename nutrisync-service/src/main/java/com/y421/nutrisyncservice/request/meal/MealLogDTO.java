package com.y421.nutrisyncservice.request.meal;

import com.y421.nutrisyncservice.entity.foodMaster.FoodMaster;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MealLogDTO {

    private Long logId;
    private FoodMaster foodMaster;
    private String foodName;
    private double totalProtein;
    private double totalCarbs;
    private double totalCalories;
    private double consumedQuantity;
    private String mealTime;
    private String notes;
}
