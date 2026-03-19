package com.y421.nutrisyncservice.request.impactSimulation;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import com.y421.nutrisyncservice.response.dietPlan.DietPlanDetailedDTO;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ImpactSimulationRequestDTO {

    private Integer age;
    private String gender;
    private Float weightKg;
    private Float heightCm;
    private Float bmi;
    private Integer dailyCalorieGoal;
    private Float bodyFatPercent;
    private Integer months; // How far into the future to predict

    private DietPlanDetailedDTO dietPlan;  // Pass the active diet plan to the AI
}
