package com.y421.nutrisyncservice.response.dietPlan;

import lombok.Data;
import java.util.List;

@Data
public class MealPlanResponseDTO {
    private List<DailyPlan> weeklyPlan;

    @Data
    public static class DailyPlan {
        private String day;
        private List<Meal> meals;
    }

    @Data
    public static class Meal {
        private String mealType;
        private String recipeName;
        private Integer prepTimeMin;
        private Integer calories;
        private Integer proteinG;
        private Integer carbsG;
        private Integer fatG;
        private String imageSearchTerm;
    }
}