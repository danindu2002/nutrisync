package com.y421.nutrisyncservice.controller.reward;

import com.y421.nutrisyncservice.request.challenge.ClaimRewardDTO;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/api/v1/rewards")
public interface RewardController {

    @GetMapping("/all")
    ResponseEntity<Object> getAllRewards();

    @PostMapping("/claim")
    ResponseEntity<Object> claimReward(@RequestBody ClaimRewardDTO dto);
}
