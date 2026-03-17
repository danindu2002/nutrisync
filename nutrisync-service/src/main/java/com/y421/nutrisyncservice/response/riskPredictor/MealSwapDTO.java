package com.y421.nutrisyncservice.response.riskPredictor;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class MealSwapDTO {

    private String riskyMealName;
    private String riskyMealFact;
    private String healthyMealName;
    private String healthyMealFact;
}