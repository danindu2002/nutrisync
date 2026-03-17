package com.y421.nutrisyncservice.repository.challenge;

import com.y421.nutrisyncservice.entity.challenge.ChallengeDailyProgress;
import com.y421.nutrisyncservice.entity.challenge.UserChallenge;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ChallengeProgressRepository extends JpaRepository<ChallengeDailyProgress, Long> {

    Boolean existsByUserChallengeAndDayNumber(UserChallenge userChallenge, Integer dayNumber);
}