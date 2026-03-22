package com.y421.nutrisyncservice.response.riskPredictor;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

//This DTO is used to send post processed meal risk contribution details to the FE
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class MealRiskContributionResDTO {

    private Long logId; // meal log id contributed to the risk
    private String foodName;
    private byte[] image;
    private String contribution;
}