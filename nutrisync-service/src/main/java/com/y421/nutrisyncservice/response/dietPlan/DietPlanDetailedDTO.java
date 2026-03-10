package com.y421.nutrisyncservice.response.dietPlan;

import lombok.Data;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Data
public class DietPlanDetailedDTO {
    private Long planId;
    private String dietPlanName;
    private String dietPlanDescription;
    private String dietPlanImage;
    private Date startDate;
    private Date endDate;
    private List<DailyPlanDTO> weeklyPlan = new ArrayList<>();
}