package com.y421.nutrisyncservice.controller.rewards;

import com.y421.nutrisyncservice.controller.reward.RewardControllerImpl;
import com.y421.nutrisyncservice.request.challenge.ClaimRewardDTO;
import com.y421.nutrisyncservice.service.reward.RewardService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class RewardControllerImplTest {

    @Mock
    private RewardService rewardService;

    @InjectMocks
    private RewardControllerImpl rewardController;

    @Test
    void getAllRewards_Success() {
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("RewardList", HttpStatus.OK);
        when(rewardService.getAllRewards()).thenReturn(serviceResponse);

        ResponseEntity<Object> response = rewardController.getAllRewards();

        assertEquals(HttpStatus.OK, response.getStatusCode());
    }

    @Test
    void claimReward_Success() {
        ClaimRewardDTO dto = new ClaimRewardDTO();
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("Reward claimed successfully", HttpStatus.OK);
        when(rewardService.claimReward(any(ClaimRewardDTO.class))).thenReturn(serviceResponse);

        ResponseEntity<Object> response = rewardController.claimReward(dto);

        assertEquals(HttpStatus.OK, response.getStatusCode());
    }

    @Test
    void claimReward_EdgeCase_NotEnoughPoints() {
        ClaimRewardDTO dto = new ClaimRewardDTO();
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("Not enough points", HttpStatus.BAD_REQUEST);
        when(rewardService.claimReward(any(ClaimRewardDTO.class))).thenReturn(serviceResponse);

        ResponseEntity<Object> response = rewardController.claimReward(dto);

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
    }
    
    @Test
    void claimReward_Exception_ReturnsBadRequest() {
        ClaimRewardDTO dto = new ClaimRewardDTO();
        when(rewardService.claimReward(any(ClaimRewardDTO.class))).thenThrow(new RuntimeException("DB Connection Failed"));

        ResponseEntity<Object> response = rewardController.claimReward(dto);

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
    }

    @Test
    void claimReward_UserOrRewardNotFound() {
    // Arrange
    ClaimRewardDTO dto = new ClaimRewardDTO();

    ResponseEntity<Object> serviceResponse =
            new ResponseEntity<>("User or Reward not found", HttpStatus.NOT_FOUND);

    when(rewardService.claimReward(any(ClaimRewardDTO.class)))
            .thenReturn(serviceResponse);

    // Act
    ResponseEntity<Object> response =
            rewardController.claimReward(dto);

    // Assert
    assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
    }

    @Test
    void getAllRewards_Exception_ReturnsBadRequest() {
    // Arrange
    when(rewardService.getAllRewards())
            .thenThrow(new RuntimeException("DB error"));

    // Act
    ResponseEntity<Object> response =
            rewardController.getAllRewards();

    // Assert
    assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
    }

    @Test
    void claimReward_MultipleCalls_SameUser() {
    // Arrange
    ClaimRewardDTO dto = new ClaimRewardDTO();

    ResponseEntity<Object> serviceResponse =
            new ResponseEntity<>("Reward claimed successfully", HttpStatus.OK);

    when(rewardService.claimReward(any(ClaimRewardDTO.class)))
            .thenReturn(serviceResponse);

    // Act
    ResponseEntity<Object> response1 = rewardController.claimReward(dto);
    ResponseEntity<Object> response2 = rewardController.claimReward(dto);

    // Assert
    assertEquals(HttpStatus.OK, response1.getStatusCode());
    assertEquals(HttpStatus.OK, response2.getStatusCode());
    }

}