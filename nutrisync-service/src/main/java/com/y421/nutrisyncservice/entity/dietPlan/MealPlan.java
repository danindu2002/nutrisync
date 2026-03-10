package com.y421.nutrisyncservice.entity.dietPlan;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.util.audit.AuditModel;
import jakarta.persistence.*;
import lombok.*;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "M_MEAL_PLAN")
public class MealPlan extends AuditModel implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "M_MEAL_PLAN")
    @SequenceGenerator(sequenceName = "M_MEAL_PLAN_SEQ", allocationSize = 1, name = "M_MEAL_PLAN")
    @Column(name = "PLAN_ID", nullable = false)
    private Long planId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "USER_ID", nullable = false)
    private NutrisyncUser user;

    @Column(name = "START_DATE")
    private Date startDate;

    @Column(name = "END_DATE")
    private Date endDate;

    @Column(name = "IS_ACTIVE", nullable = false)
    private Boolean isActive = true;

    // CascadeType.ALL means when you save the MealPlan, it automatically saves the Days and Meals!
    @OneToMany(mappedBy = "mealPlan", cascade = CascadeType.ALL, orphanRemoval = true)
    @JsonManagedReference 
    private List<DailyPlan> dailyPlans = new ArrayList<>();
    
    // Helper method to keep relationships in sync
    public void addDailyPlan(DailyPlan dailyPlan) {
        dailyPlans.add(dailyPlan);
        dailyPlan.setMealPlan(this);
    }
}