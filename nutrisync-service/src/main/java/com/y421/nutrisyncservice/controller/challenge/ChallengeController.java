package com.y421.nutrisyncservice.controller.challenge;

import com.y421.nutrisyncservice.request.challenge.JoinChallengeDTO;
import com.y421.nutrisyncservice.request.challenge.LogProgressDTO;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequestMapping("/api/v1/challenges")
public interface ChallengeController {

    @GetMapping("/all")
    ResponseEntity<Object> getAllChallenges();

    @GetMapping("/available/{userId}")
    ResponseEntity<Object> getAvailableChallenges(@PathVariable Long userId);

    @GetMapping("/active/{userId}")
    ResponseEntity<Object> getActiveChallenges(@PathVariable Long userId);

    @GetMapping("/{challengeId}")
    ResponseEntity<Object> getChallengeDetails(@PathVariable Long challengeId);

    @GetMapping("/user-points/{userId}")
    ResponseEntity<Object> getUserPoints(@PathVariable Long userId);

    @PostMapping("/join")
    ResponseEntity<Object> joinChallenge(@RequestBody JoinChallengeDTO dto);

    @PostMapping("/log-progress")
    ResponseEntity<Object> logProgress(@RequestBody LogProgressDTO dto);
}
