package com.y421.nutrisyncservice.entity.mealLog;

import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.util.audit.AuditModel;
import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;

@Entity
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
@Table(name = "T_MEAL_LOG")
public class MealLog extends AuditModel implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "T_MEAL_LOG")
    @SequenceGenerator(name = "T_MEAL_LOG_SEQ", sequenceName = "T_MEAL_LOG", allocationSize = 1)
    private Long logId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "USER_ID", nullable = false)
    private NutrisyncUser user;

    @Column(name = "IDENTIFIED_FOOD")
    private String identifiedFood;

    @Column(name = "IMAGE_URL")
    private String imageUrl; // Path to the uploaded image

    @Column(name = "CONSUMED_CALORIES")
    private Float consumedCalories;

    @Column(name = "MEAL_TYPE")
    private String mealType; // BREAKFAST, LUNCH, etc.
}