package com.y421.nutrisyncservice.service.reward;

import com.y421.nutrisyncservice.request.challenge.ClaimRewardDTO;
import org.springframework.http.ResponseEntity;

public interface RewardService {

    ResponseEntity<Object> getAllRewards();
    ResponseEntity<Object> claimReward(ClaimRewardDTO dto);
}