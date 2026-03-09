package com.y421.nutrisyncservice.entity.riskPredictor;

import com.y421.nutrisyncservice.util.audit.AuditModel;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.util.Date;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "M_RISK_PREDICTOR")
public class RiskPredictor extends AuditModel implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "M_RISK_PREDICTOR")
    @SequenceGenerator(sequenceName = "M_RISK_PREDICTOR_SEQ", allocationSize = 1, name = "M_RISK_PREDICTOR")
    @Column(name = "PREDICTION_ID", nullable = false)
    private Long predictionId;

    @Column(name = "PREDICTION_DATE")
    private Date predictionDate;

    @Column(name = "TARGET_CALORIES")
    private Float targetCalories;

    @Column(name = "OBESITY_RISK")
    private Float obesityRisk;

    @Column(name = "CHOLESTEROL_RISK")
    private Float cholesterolRisk;

    @Column(name = "DIABETES_RISK")
    private Float diabetesRisk;

    @Column(name = "CONFIDENCE_LEVEL")
    private Float confidenceLevel;

    @Column(name = "ADVISOR")
    private String advisor;

}
