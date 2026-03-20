package com.y421.nutrisyncservice.entity.challenge;

import com.y421.nutrisyncservice.util.audit.AuditModel;
import jakarta.persistence.*;
import lombok.*;
import java.io.Serializable;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "M_CHALLENGE")
public class Challenge extends AuditModel implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "M_CHALLENGE")
    @SequenceGenerator(sequenceName = "M_CHALLENGE_SEQ", allocationSize = 1, name = "M_CHALLENGE")
    @Column(name = "CHALLENGE_ID")
    private Long challengeId;

    @Column(name = "NAME", nullable = false)
    private String name;

    @Column(name = "DESCRIPTION")
    private String description;

    @Column(name = "DURATION_DAYS")
    private Integer durationDays;

    @Column(name = "METRIC_TYPE")
    private String metricType; // water, calories

    @Column(name = "DAILY_TARGET")
    private Integer dailyTarget;

    @Column(name = "POINTS_REWARD")
    private Integer pointsReward;

    @Column(name = "REPEATABLE")
    private Boolean repeatable;
}
