package com.y421.nutrisyncservice.request.dietPlan;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.Date;

@Data
@AllArgsConstructor
public class MealPlanSummaryDTO {
    private Long planId;
    private String dietPlanName;
    private String dietPlanDescription;
    private String dietPlanImage;
    private Date startDate;
    private Date endDate;
    private Boolean isActive;
}