package com.y421.nutrisyncservice.entity.foodMaster;

import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;

@Entity
@Getter
@Setter @NoArgsConstructor
@AllArgsConstructor
@Table(name = "M_FOOD_MASTER")
public class FoodMaster implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "FOOD_ID")
    private Long foodId;

    @Column(name = "LABEL", nullable = false)
    private String label;

    @Column(name = "CALORIES")
    private Float calories;

    @Column(name = "PROTEIN")
    private Float protein;

    @Column(name = "CARBOHYDRATES")
    private Float carbohydrates;

    @Column(name = "FATS")
    private Float fats;

    @Column(name = "FIBER")
    private Float fiber;

    @Column(name = "SUGARS")
    private Float sugars;

    @Column(name = "SODIUM")
    private Float sodium;
    
    @Column(name = "CATEGORY")
    private String category;
}