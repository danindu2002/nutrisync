package com.y421.nutrisyncservice.response.dashboard;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class NutritionChartDTO {
    private List<String> labels;
    private List<Double> values;
    private String range;
}