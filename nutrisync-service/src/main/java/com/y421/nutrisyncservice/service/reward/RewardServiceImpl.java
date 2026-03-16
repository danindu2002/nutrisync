package com.y421.nutrisyncservice.service.reward;

import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.entity.reward.Reward;
import com.y421.nutrisyncservice.entity.reward.UserReward;
import com.y421.nutrisyncservice.repository.nutrisyncUser.NutrisyncUserRepository;
import com.y421.nutrisyncservice.repository.reward.RewardRepository;
import com.y421.nutrisyncservice.repository.reward.UserRewardRepository;
import com.y421.nutrisyncservice.request.challenge.ClaimRewardDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class RewardServiceImpl implements RewardService {

    private final RewardRepository rewardRepository;
    private final UserRewardRepository userRewardRepository;
    private final NutrisyncUserRepository userRepository;

    @Override
    public ResponseEntity<Object> getAllRewards() {

        List<Reward> rewards = rewardRepository.findAll();
        return new ResponseEntity<>(rewards, HttpStatus.OK);
    }

    @Override
    public ResponseEntity<Object> claimReward(ClaimRewardDTO dto) {

        Optional<NutrisyncUser> userOpt = userRepository.findById(dto.getUserId());
        Optional<Reward> rewardOpt = rewardRepository.findById(dto.getRewardId());

        if (userOpt.isEmpty() || rewardOpt.isEmpty()) {
            return new ResponseEntity<>("User or Reward not found", HttpStatus.NOT_FOUND);
        }

        NutrisyncUser user = userOpt.get();
        Reward reward = rewardOpt.get();

        if (user.getPoints() == null || (user.getPoints() < reward.getCostPoints())) {
            return new ResponseEntity<>("Not enough points", HttpStatus.BAD_REQUEST);
        }

        user.setPoints(user.getPoints() - reward.getCostPoints());

        UserReward userReward = new UserReward();
        userReward.setUser(user);
        userReward.setReward(reward);
        userReward.setClaimedAt(LocalDateTime.now());

        userRepository.save(user);
        userRewardRepository.save(userReward);

        if (reward.getPremiumDurationDays() != null) {

            LocalDateTime now = LocalDateTime.now();

            if (user.getPremiumExpireDate() != null && user.getPremiumExpireDate().isAfter(now)) {
                // extend existing premium
                user.setPremiumExpireDate(
                        user.getPremiumExpireDate().plusDays(reward.getPremiumDurationDays())
                );
            } else {
                // start new premium
                user.setPremiumExpireDate(
                        now.plusDays(reward.getPremiumDurationDays())
                );
            }
        }

        return new ResponseEntity<>("Reward claimed successfully", HttpStatus.OK);
    }
}
