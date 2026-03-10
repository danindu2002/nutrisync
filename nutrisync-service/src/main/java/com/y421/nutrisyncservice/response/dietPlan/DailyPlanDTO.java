package com.y421.nutrisyncservice.response.dietPlan;

import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
public class DailyPlanDTO {
    private String day;
    private List<PlannedMealDTO> meals = new ArrayList<>();
}
