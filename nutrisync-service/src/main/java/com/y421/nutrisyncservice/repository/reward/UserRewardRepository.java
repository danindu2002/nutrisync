package com.y421.nutrisyncservice.repository.reward;

import com.y421.nutrisyncservice.entity.reward.UserReward;
import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserRewardRepository extends JpaRepository<UserReward, Long> {

    List<UserReward> findByUser(NutrisyncUser user);
}
