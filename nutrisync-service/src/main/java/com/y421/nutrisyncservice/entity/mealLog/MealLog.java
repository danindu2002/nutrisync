package com.y421.nutrisyncservice.entity.mealLog;

import com.y421.nutrisyncservice.entity.foodMaster.FoodMaster;
import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.util.audit.AuditModel;
import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "M_MEAL_LOG")
public class MealLog extends AuditModel implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "LOG_ID")
    private Long logId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "USER_ID", nullable = false)
    private NutrisyncUser user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "FOOD_ID")
    private FoodMaster foodMaster;

    @Column(name = "FOOD_NAME")
    private String foodName; // For manually entered food items

    @Column(name = "TOTAL_PROTEIN")
    private Float totalProtein; // Total protein content based on consumed quantity (g)

    @Column(name = "TOTAL_CARBS")
    private Float totalCarbs; // Total carbohydrates content based on consumed quantity (g)

    @Column(name = "TOTAL_CALORIES")
    private Float totalCalories; // Total calories content based on consumed quantity (kcal)

    @Column(name = "TOTAL_FATS")
    private Float totalFats; // Total fat content based on consumed quantity (g)

    @Column(name = "CONSUMED_QUANTITY")
    private Float consumedQuantity; // Quantity consumed by the user (g)

    @Lob
    @Column(name = "IMAGE", length = 20971520)
    private byte[] image; // Optional image of the meal

    @Column(name = "MEAL_TIME")
    private MealTime mealTime;

    @Column(name = "NOTES")
    private String notes;

    @Column(name = "SUGGEST_RECOMMENDATIONS")
    private Boolean suggestRecommendations;

    @Column(name = "IS_DELETED", nullable = false)
    private Boolean isDeleted = false;
}