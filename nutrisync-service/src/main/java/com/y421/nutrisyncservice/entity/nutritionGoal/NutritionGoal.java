package com.y421.nutrisyncservice.entity.nutritionGoal;

import com.y421.nutrisyncservice.util.audit.AuditModel;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "M_NUTRITION_GOAL")
public class NutritionGoal extends AuditModel implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "M_NUTRITION_GOAL")
    @SequenceGenerator(sequenceName = "M_NUTRITION_GOAL_SEQ", allocationSize = 1, name = "M_NUTRITION_GOAL")
    @Column(name = "GOAL_ID", nullable = false)
    private Long userId;

    @Column(name = "TARGET_CALORIES")
    private Float targetCalories;

    // todo: add other fields as necessary
}
