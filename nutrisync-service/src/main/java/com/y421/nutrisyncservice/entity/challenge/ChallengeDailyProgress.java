package com.y421.nutrisyncservice.entity.challenge;

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
@Table(name = "T_CHALLENGE_PROGRESS",
        uniqueConstraints = @UniqueConstraint(columnNames = {"USER_CHALLENGE_ID", "DAY_NUMBER"}))
public class ChallengeDailyProgress extends AuditModel implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "T_CHALLENGE_PROGRESS")
    @SequenceGenerator(sequenceName = "T_CHALLENGE_PROGRESS_SEQ", allocationSize = 1, name = "T_CHALLENGE_PROGRESS")
    @Column(name = "PROGRESS_ID")
    private Long progressId;

    @ManyToOne
    @JoinColumn(name = "USER_CHALLENGE_ID")
    private UserChallenge userChallenge;

    @Column(name = "DAY_NUMBER")
    private Integer dayNumber;

    @Column(name = "LOG_DATE")
    private LocalDate logDate;

    @Column(name = "COMPLETED")
    private Boolean completed;
}
