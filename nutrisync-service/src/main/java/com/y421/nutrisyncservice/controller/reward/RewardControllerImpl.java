package com.y421.nutrisyncservice.controller.reward;

import com.y421.nutrisyncservice.request.challenge.ClaimRewardDTO;
import com.y421.nutrisyncservice.service.reward.RewardService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

import static com.y421.nutrisyncservice.util.ResponseHandler.generateResponse;

@RestController
@RequiredArgsConstructor
public class RewardControllerImpl implements RewardController {

    private final RewardService rewardService;

    @Override
    public ResponseEntity<Object> getAllRewards() {
        try {
            ResponseEntity<Object> response = rewardService.getAllRewards();
            return generateResponse("Rewards Retrieved Successfully", HttpStatus.OK, response.getBody());
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }

    @Override
    public ResponseEntity<Object> claimReward(ClaimRewardDTO dto) {
        try {
            ResponseEntity<Object> response = rewardService.claimReward(dto);
            return generateResponse("Reward Claimed Successfully", HttpStatus.OK, response.getBody());
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }
}
