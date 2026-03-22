package com.y421.nutrisyncservice.entity.reward;

import com.y421.nutrisyncservice.util.audit.AuditModel;
import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "M_REWARD")
public class Reward extends AuditModel implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "M_REWARD")
    @SequenceGenerator(sequenceName = "M_REWARD_SEQ", allocationSize = 1, name = "M_REWARD")
    @Column(name = "REWARD_ID")
    private Long rewardId;

    @Column(name = "NAME", nullable = false)
    private String name;

    @Column(name = "DESCRIPTION")
    private String description;

    @Column(name = "COST_POINTS")
    private Integer costPoints;

    @Column(name = "PREMIUM_DURATION_DAYS")
    private Integer premiumDurationDays;
}
