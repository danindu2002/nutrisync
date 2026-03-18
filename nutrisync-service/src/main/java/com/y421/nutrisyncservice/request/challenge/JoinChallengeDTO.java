package com.y421.nutrisyncservice.request.challenge;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class JoinChallengeDTO {

    private Long userId;
    private Long challengeId;
}
