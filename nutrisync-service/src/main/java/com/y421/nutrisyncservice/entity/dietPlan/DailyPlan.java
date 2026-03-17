package com.y421.nutrisyncservice.entity.dietPlan;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.y421.nutrisyncservice.util.audit.AuditModel;
import jakarta.persistence.*;
import lombok.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "M_DAILY_PLAN")
public class DailyPlan extends AuditModel implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "M_DAILY_PLAN")
    @SequenceGenerator(sequenceName = "M_DAILY_PLAN_SEQ", allocationSize = 1, name = "M_DAILY_PLAN")
    @Column(name = "DAILY_PLAN_ID", nullable = false)
    private Long dailyPlanId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PLAN_ID", nullable = false)
    @JsonBackReference
    private MealPlan mealPlan;

    @Column(name = "DAY_OF_WEEK", nullable = false)
    private String dayOfWeek; // e.g., "Monday"

    @OneToMany(mappedBy = "dailyPlan", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonManagedReference
    private List<PlannedMeal> plannedMeals = new ArrayList<>();

    // Helper method
    public void addPlannedMeal(PlannedMeal meal) {
        plannedMeals.add(meal);
        meal.setDailyPlan(this);
    }
}