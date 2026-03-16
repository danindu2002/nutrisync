package com.y421.nutrisyncservice.repository.challenge;

import com.y421.nutrisyncservice.entity.challenge.Challenge;
import com.y421.nutrisyncservice.entity.challenge.ChallengeStatus;
import com.y421.nutrisyncservice.entity.challenge.UserChallenge;
import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserChallengeRepository extends JpaRepository<UserChallenge, Long> {

    Optional<UserChallenge> findByUserChallengeIdAndStatus(Long id, ChallengeStatus status);

    Integer countByUserAndChallenge(NutrisyncUser user, Challenge challenge);

    List<UserChallenge> findByUser(NutrisyncUser user);

    List<UserChallenge> findByUserAndStatus(NutrisyncUser user, ChallengeStatus status);
}
