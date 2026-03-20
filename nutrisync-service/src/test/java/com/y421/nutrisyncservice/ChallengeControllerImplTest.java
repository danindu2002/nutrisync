package com.y421.nutrisyncservice;

import com.y421.nutrisyncservice.controller.challenge.ChallengeControllerImpl;
import com.y421.nutrisyncservice.request.challenge.JoinChallengeDTO;
import com.y421.nutrisyncservice.request.challenge.LogProgressDTO;
import com.y421.nutrisyncservice.service.challenge.ChallengeService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ChallengeControllerImplTest {

    @Mock
    private ChallengeService challengeService;

    @InjectMocks
    private ChallengeControllerImpl challengeController;

    private JoinChallengeDTO joinChallengeDTO;
    private LogProgressDTO logProgressDTO;

    @BeforeEach
    void setUp() {
        joinChallengeDTO = new JoinChallengeDTO();
        logProgressDTO = new LogProgressDTO();
    }

    @Test
    void getAllChallenges_Success() {
        // Arrange
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("mockData", HttpStatus.OK);
        when(challengeService.getAllChallenges()).thenReturn(serviceResponse);

        // Act
        ResponseEntity<Object> response = challengeController.getAllChallenges();

        // Assert
        assertNotNull(response);
        assertEquals(HttpStatus.OK, response.getStatusCode());
    }

    @Test
    void getAllChallenges_ExceptionThrown_ReturnsBadRequest() {
        // Arrange
        when(challengeService.getAllChallenges()).thenThrow(new RuntimeException("Database down"));

        // Act
        ResponseEntity<Object> response = challengeController.getAllChallenges();

        // Assert
        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
    }

    @Test
    void joinChallenge_Success() {
        // Arrange
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("Joined", HttpStatus.OK);
        when(challengeService.joinChallenge(any(JoinChallengeDTO.class))).thenReturn(serviceResponse);

        // Act
        ResponseEntity<Object> response = challengeController.joinChallenge(joinChallengeDTO);

        // Assert
        assertNotNull(response);
        assertEquals(HttpStatus.OK, response.getStatusCode());
    }

    @Test
    void logProgress_Success() {
        // Arrange
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("Logged", HttpStatus.OK);
        when(challengeService.logProgress(any(LogProgressDTO.class))).thenReturn(serviceResponse);

        // Act
        ResponseEntity<Object> response = challengeController.logProgress(logProgressDTO);

        // Assert
        assertNotNull(response);
        assertEquals(HttpStatus.OK, response.getStatusCode());
    }
}