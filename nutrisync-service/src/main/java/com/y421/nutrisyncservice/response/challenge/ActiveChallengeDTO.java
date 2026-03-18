package com.y421.nutrisyncservice.response.challenge;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ActiveChallengeDTO {

    private Long userChallengeId;
    private String challengeName;
    private String description;

    private Integer durationDays;
    private Integer completedDays;

    private Integer daysLeft;
    private Double progressPercentage;

    private Integer pointsReward;
}
