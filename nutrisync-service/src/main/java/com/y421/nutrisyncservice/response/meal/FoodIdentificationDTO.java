package com.y421.nutrisyncservice.response.meal;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class FoodIdentificationDTO {
    private Long foodId;
    private String name;
    private String calories; // per 100g
    private String protein;
    private String carbohydrates;
    private String fats;
}