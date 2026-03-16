package com.y421.nutrisyncservice.entity.reward;

import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.util.audit.AuditModel;
import jakarta.persistence.*;
import lombok.*;

import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "T_USER_REWARD")
public class UserReward extends AuditModel implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "T_USER_REWARD")
    @SequenceGenerator(sequenceName = "T_USER_REWARD_SEQ", allocationSize = 1, name = "T_USER_REWARD")
    @Column(name = "USER_REWARD_ID")
    private Long userRewardId;

    @ManyToOne
    @JoinColumn(name = "USER_ID")
    private NutrisyncUser user;

    @ManyToOne
    @JoinColumn(name = "REWARD_ID")
    private Reward reward;

    @Column(name = "CLAIMED_AT")
    private LocalDateTime claimedAt;
}
