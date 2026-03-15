package com.y421.nutrisyncservice.response.riskPredictor;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class RiskPredictDTO {
    private String predictedRisk;
    private String reasonTitle;
    private String probability;
    private String warning;
    private List<MealRiskContributionDTO> mealRiskContributionList;
}