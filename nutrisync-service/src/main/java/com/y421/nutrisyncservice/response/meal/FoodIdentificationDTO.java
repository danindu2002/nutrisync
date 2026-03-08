package com.y421.nutrisyncservice.response.meal;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class FoodIdentificationDTO {
    private Long foodId;
    private String name;
    private String caloriesInKcal;
    private String proteinInG;
    private String carbohydratesInG;
    private String totalFatsInG;
    private String calciumInMg;
    private String fiberInG;
    private String sugarsInG;
    private String fructoseInG;
    private String glucoseInG;
    private String lactoseInG;
    private String sodiumInMg;
    private String cholesterolInMg;
    private String waterInG;
}