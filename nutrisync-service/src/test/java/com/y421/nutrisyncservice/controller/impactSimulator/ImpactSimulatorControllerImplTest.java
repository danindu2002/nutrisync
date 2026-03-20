package com.y421.nutrisyncservice.controller.impactSimulator;
 
import com.y421.nutrisyncservice.service.impactSimulator.ImpactSimulatorService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
 
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.when;
 
@ExtendWith(MockitoExtension.class)
class ImpactSimulatorControllerImplTest {
 
    @Mock
    private ImpactSimulatorService impactSimulatorService;
 
    @InjectMocks
    private ImpactSimulatorControllerImpl impactSimulatorController;
 
    // --- getUserBMI Tests ---
 
    @Test
    void getUserBMI_Success() {
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>(24.5, HttpStatus.OK);
        when(impactSimulatorService.getUserBMI(1L)).thenReturn(serviceResponse);
 
        ResponseEntity<Object> response = impactSimulatorController.getUserBMI(1L);
 
        assertEquals(HttpStatus.OK, response.getStatusCode());
    }
 
    @Test
    void getUserBMI_EdgeCase_UserMissingVitals() {
        // Edge Case: User exists, but hasn't entered height/weight, so BMI calculation fails
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("Incomplete user profile", HttpStatus.CONFLICT);
        when(impactSimulatorService.getUserBMI(2L)).thenReturn(serviceResponse);
 
        ResponseEntity<Object> response = impactSimulatorController.getUserBMI(2L);
 
        assertEquals(HttpStatus.CONFLICT, response.getStatusCode());
    }
 
    @Test
    void getUserBMI_Exception_ReturnsBadRequest() {
        when(impactSimulatorService.getUserBMI(anyLong())).thenThrow(new IllegalArgumentException("Invalid ID"));
 
        ResponseEntity<Object> response = impactSimulatorController.getUserBMI(1L);
 
        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
    }
 
    // --- simulateImpact Tests ---
 
    @Test
    void simulateImpact_Success() {
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("SimulationData", HttpStatus.OK);
        when(impactSimulatorService.simulateImpact(1L, 3)).thenReturn(serviceResponse);
 
        ResponseEntity<Object> response = impactSimulatorController.simulateImpact(1L, 3);
 
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
    }
 
    @Test
    void simulateImpact_Exception_ReturnsBadRequestFallback() {
        // Catch-all exception block test
        when(impactSimulatorService.simulateImpact(anyLong(), anyInt())).thenThrow(new RuntimeException("AI Core Down"));
 
        ResponseEntity<Object> response = impactSimulatorController.simulateImpact(1L, 6);
 
        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
    }
}