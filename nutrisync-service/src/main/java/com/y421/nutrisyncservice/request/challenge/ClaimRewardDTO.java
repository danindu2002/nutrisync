package com.y421.nutrisyncservice.request.challenge;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ClaimRewardDTO {

    private Long userId;
    private Long rewardId;
}