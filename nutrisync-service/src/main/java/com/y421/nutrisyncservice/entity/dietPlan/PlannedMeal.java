package com.y421.nutrisyncservice.entity.dietPlan;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.y421.nutrisyncservice.entity.mealLog.MealTime;
import com.y421.nutrisyncservice.util.audit.AuditModel;
import jakarta.persistence.*;
import lombok.*;
import java.io.Serializable;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "M_PLANNED_MEAL")
public class PlannedMeal extends AuditModel implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "M_PLANNED_MEAL")
    @SequenceGenerator(sequenceName = "M_PLANNED_MEAL_SEQ", allocationSize = 1, name = "M_PLANNED_MEAL")
    @Column(name = "PLANNED_MEAL_ID", nullable = false)
    private Long plannedMealId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DAILY_PLAN_ID", nullable = false)
    @JsonBackReference
    private DailyPlan dailyPlan;

    @Column(name = "MEAL_TIME", nullable = false)
    private MealTime mealType; // Breakfast, Lunch, Dinner, Snack

    @Column(name = "RECIPE_NAME", nullable = false)
    private String recipeName;

    @Column(name = "PREP_TIME_MIN")
    private Integer prepTimeMin;

    @Column(name = "CALORIES")
    private Integer calories;

    @Column(name = "PROTEIN_G")
    private Integer proteinG;

    @Column(name = "CARBS_G")
    private Integer carbsG;

    @Column(name = "FAT_G")
    private Integer fatG;

    @Column(name = "IS_EATEN", nullable = false)
    private Boolean isEaten = false; // For checking off meals in the UI

    @Column(name = "image_search_term")
    private String imageSearchTerm;
}