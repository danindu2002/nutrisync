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
public class CaloriesChartDTO {
    private List<String> labels;
    private List<Double> values;
    private Double totalCalories;
    private String range;
}