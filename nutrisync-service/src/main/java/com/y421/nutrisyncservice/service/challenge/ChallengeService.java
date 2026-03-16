package com.y421.nutrisyncservice.service.challenge;

import com.y421.nutrisyncservice.request.challenge.JoinChallengeDTO;
import com.y421.nutrisyncservice.request.challenge.LogProgressDTO;
import org.springframework.http.ResponseEntity;

public interface ChallengeService {
    ResponseEntity<Object> getAllChallenges();
    ResponseEntity<Object> getAvailableChallenges(Long userId);
    ResponseEntity<Object> getActiveChallenges(Long userId);
    ResponseEntity<Object> getChallengeDetails(Long challengeId);
    ResponseEntity<Object> getUserPoints(Long userId);
    ResponseEntity<Object> joinChallenge(JoinChallengeDTO dto);
    ResponseEntity<Object> logProgress(LogProgressDTO dto);
}
