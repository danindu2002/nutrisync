package com.y421.nutrisyncservice.controller.challenge;

import com.y421.nutrisyncservice.request.challenge.JoinChallengeDTO;
import com.y421.nutrisyncservice.request.challenge.LogProgressDTO;
import com.y421.nutrisyncservice.service.challenge.ChallengeService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

import static com.y421.nutrisyncservice.util.ResponseHandler.generateResponse;

@RestController
@RequiredArgsConstructor
public class ChallengeControllerImpl implements ChallengeController {

    private final ChallengeService challengeService;

    @Override
    public ResponseEntity<Object> getAllChallenges() {
        try {
            ResponseEntity<Object> response = challengeService.getAllChallenges();
            return generateResponse("Challenges Retrieved Successfully", HttpStatus.OK, response.getBody());
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }

    @Override
    public ResponseEntity<Object> getAvailableChallenges(Long userId) {
        try {
            ResponseEntity<Object> response = challengeService.getAvailableChallenges(userId);
            return generateResponse("Challenges Retrieved Successfully", HttpStatus.OK, response.getBody());
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }

    @Override
    public ResponseEntity<Object> getActiveChallenges(Long userId) {
        try {
            ResponseEntity<Object> response = challengeService.getActiveChallenges(userId);
            return generateResponse("Challenges Retrieved Successfully", HttpStatus.OK, response.getBody());
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }

    @Override
    public ResponseEntity<Object> getChallengeDetails(Long challengeId) {
        try {
            ResponseEntity<Object> response = challengeService.getChallengeDetails(challengeId);
            return generateResponse("Challenge Retrieved Successfully", HttpStatus.OK, response.getBody());
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }

    @Override
    public ResponseEntity<Object> getUserPoints(Long userId) {
        try {
            ResponseEntity<Object> response = challengeService.getUserPoints(userId);
            return generateResponse("Points Retrieved Successfully", HttpStatus.OK, response.getBody());
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }

    @Override
    public ResponseEntity<Object> joinChallenge(JoinChallengeDTO dto) {
        try {
            ResponseEntity<Object> response = challengeService.joinChallenge(dto);
            return generateResponse("Joined Challenge Successfully", HttpStatus.OK, response.getBody());
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }

    @Override
    public ResponseEntity<Object> logProgress(LogProgressDTO dto) {
        try {
            ResponseEntity<Object> response = challengeService.logProgress(dto);
            return generateResponse("Challenge Logged Successfully", HttpStatus.OK, response.getBody());
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }
}