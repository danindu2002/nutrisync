package com.y421.nutrisyncservice.repository.reward;

import com.y421.nutrisyncservice.entity.reward.Reward;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RewardRepository extends JpaRepository<Reward, Long> {

}
