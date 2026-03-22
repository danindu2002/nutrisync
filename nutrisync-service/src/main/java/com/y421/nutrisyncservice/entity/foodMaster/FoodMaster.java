package com.y421.nutrisyncservice.entity.foodMaster;

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "M_FOOD_MASTER")
public class FoodMaster implements Serializable {

    // All macros show per 100g of the food item
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "FOOD_ID")
    private Long foodId;

    @Column(name = "NAME", nullable = false)
    private String name;

    @Column(name = "CALORIES_IN_KCAL")
    private String caloriesInKcal;

    @Column(name = "PROTEIN_IN_G")
    private String proteinInG;

    @Column(name = "CARBOHYDRATES_IN_G")
    private String carbohydratesInG;

    @Column(name = "TOTAL_FATS_IN_G")
    private String totalFatsInG;

    @Column(name = "CALCIUM_IN_MG")
    private String calciumInMg;

    @Column(name = "FIBER_IN_G")
    private String fiberInG;

    @Column(name = "SUGARS_IN_G")
    private String sugarsInG;

    @Column(name = "FRUCTOSE_IN_G")
    private String fructoseInG;

    @Column(name = "GLUCOSE_IN_G")
    private String glucoseInG;

    @Column(name = "LACTOSE_IN_G")
    private String lactoseInG;

    @Column(name = "SODIUM_IN_MG")
    private String sodiumInMg;

    @Column(name = "CHOLESTEROL_IN_MG")
    private String cholesterolInMg;

    @Column(name = "WATER_IN_G")
    private String waterInG;
    
    @Column(name = "CATEGORY")
    private String category;

    @Column(name = "IS_MANUAL")
    private Boolean isManual = false;
}