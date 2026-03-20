package com.y421.nutrisyncservice;

import com.y421.nutrisyncservice.controller.riskPredictor.RiskPredictorControllerImpl;
import com.y421.nutrisyncservice.service.riskPredictor.RiskPredictorService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class RiskPredictorControllerImplTest {

    @Mock
    private RiskPredictorService riskPredictorService;

    @InjectMocks
    private RiskPredictorControllerImpl riskPredictorController;

    @Test
    void predictRisk_Success() {
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("RiskPredictionData", HttpStatus.OK);
        when(riskPredictorService.predictRisk(anyLong(), anyInt())).thenReturn(serviceResponse);

        ResponseEntity<Object> response = riskPredictorController.predictRisk(1L, 5);

        assertEquals(HttpStatus.OK, response.getStatusCode());
    }

    @Test
    void predictRisk_EdgeCase_RateLimitHit() {
        // AI Services often throw 429 Too Many Requests, the controller should handle passing this gracefully
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("AI Rate Limit Exceeded", HttpStatus.TOO_MANY_REQUESTS);
        when(riskPredictorService.predictRisk(1L, 5)).thenReturn(serviceResponse);

        ResponseEntity<Object> response = riskPredictorController.predictRisk(1L, 5);

        assertEquals(HttpStatus.TOO_MANY_REQUESTS, response.getStatusCode());
    }

    @Test
    void predictRisk_EdgeCase_NoMealLogs() {
        // Testing situation where the user has no logs to base a prediction on
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("No meal logs found", HttpStatus.CONFLICT);
        when(riskPredictorService.predictRisk(2L, 5)).thenReturn(serviceResponse);

        ResponseEntity<Object> response = riskPredictorController.predictRisk(2L, 5);

        assertEquals(HttpStatus.CONFLICT, response.getStatusCode());
    }

    @Test
    void predictRisk_Exception_ReturnsBadRequest() {
        when(riskPredictorService.predictRisk(anyLong(), anyInt())).thenThrow(new RuntimeException("AI Service Down"));

        ResponseEntity<Object> response = riskPredictorController.predictRisk(1L, 5);

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
    }
}