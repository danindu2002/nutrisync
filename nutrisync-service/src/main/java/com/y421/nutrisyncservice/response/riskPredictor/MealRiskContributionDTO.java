package com.y421.nutrisyncservice.response.riskPredictor;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class MealRiskContributionDTO {
    private String logId; // meal log id contributed to the risk
    private String contribution;
}