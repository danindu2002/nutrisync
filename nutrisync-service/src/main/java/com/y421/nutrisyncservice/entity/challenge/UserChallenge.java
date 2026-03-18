package com.y421.nutrisyncservice.entity.challenge;

import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.util.audit.AuditModel;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.time.LocalDate;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "T_USER_CHALLENGE")
public class UserChallenge extends AuditModel implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "T_USER_CHALLENGE")
    @SequenceGenerator(sequenceName = "T_USER_CHALLENGE_SEQ", allocationSize = 1, name = "T_USER_CHALLENGE")
    @Column(name = "USER_CHALLENGE_ID")
    private Long userChallengeId;

    @ManyToOne
    @JoinColumn(name = "USER_ID")
    private NutrisyncUser user;

    @ManyToOne
    @JoinColumn(name = "CHALLENGE_ID")
    private Challenge challenge;

    @Column(name = "START_DATE")
    private LocalDate startDate;

    @Column(name = "END_DATE")
    private LocalDate endDate;

    @Column(name = "COMPLETED_DAYS")
    private Integer completedDays;

    @Column(name = "ATTEMPT_NUMBER")
    private Integer attemptNumber;

    @Enumerated(EnumType.STRING)
    @Column(name = "STATUS")
    private ChallengeStatus status;
}
