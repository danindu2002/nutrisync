package com.y421.nutrisyncservice.response.impactSimulation;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ImpactSimulationResponseDTO {

    private Double projectedBmi;
    private Double projectedWeightKg;
    private Double projectedBodyFatPercent;
    private Double waistToHipRatio;
    private String expectedConsistencyLevel;

    // Change metrics (e.g., -8.1, -16.0)
    private Double bmiChange;
    private Double weightChangeKg;
    private Double bodyFatChangePercent;
}
