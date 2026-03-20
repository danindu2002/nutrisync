package com.y421.nutrisyncservice;

import com.y421.nutrisyncservice.controller.dietPlan.DietPlanControllerImpl;
import com.y421.nutrisyncservice.request.dietPlan.SaveMealPlanRequest;
import com.y421.nutrisyncservice.request.dietPlan.UpdateMealPlanDetailsRequest;
import com.y421.nutrisyncservice.service.dietPlan.DietPlanService;
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
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class DietPlanControllerImplTest {

    @Mock
    private DietPlanService dietPlanService;

    @InjectMocks
    private DietPlanControllerImpl dietPlanController;

    private SaveMealPlanRequest saveMealPlanRequest;
    private UpdateMealPlanDetailsRequest updateRequest;

    @BeforeEach
    void setUp() {
        saveMealPlanRequest = new SaveMealPlanRequest();
        updateRequest = new UpdateMealPlanDetailsRequest();
    }

    // --- generateMealPlanPreview Tests ---

    @Test
    void generateMealPlanPreview_Success() {
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("PlanGenerated", HttpStatus.OK);
        when(dietPlanService.generateMealPlanPreview(1L)).thenReturn(serviceResponse);

        ResponseEntity<Object> response = dietPlanController.generateMealPlanPreview(1L);

        assertEquals(HttpStatus.OK, response.getStatusCode());
    }

    @Test
    void generateMealPlanPreview_EdgeCase_RateLimitExceeded() {
        // Edge case: AI generation hits a 429 Too Many Requests rate limit
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("Rate limit exceeded", HttpStatus.TOO_MANY_REQUESTS);
        when(dietPlanService.generateMealPlanPreview(1L)).thenReturn(serviceResponse);

        ResponseEntity<Object> response = dietPlanController.generateMealPlanPreview(1L);

        // Controller should pass the 429 status forward, not swallow it to 200 or 400
        assertEquals(HttpStatus.TOO_MANY_REQUESTS, response.getStatusCode());
    }

    @Test
    void generateMealPlanPreview_Exception_ReturnsBadRequest() {
        when(dietPlanService.generateMealPlanPreview(anyLong())).thenThrow(new RuntimeException("Pexels API Down"));

        ResponseEntity<Object> response = dietPlanController.generateMealPlanPreview(1L);

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
    }

    // --- saveMealPlan Tests ---

    @Test
    void saveMealPlan_Success() {
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("Saved", HttpStatus.OK);
        when(dietPlanService.saveMealPlan(any(SaveMealPlanRequest.class))).thenReturn(serviceResponse);

        ResponseEntity<Object> response = dietPlanController.saveMealPlan(saveMealPlanRequest);

        assertEquals(HttpStatus.OK, response.getStatusCode());
    }

    // --- updateDietPlanDetails Tests ---

    @Test
    void updateDietPlanDetails_EdgeCase_PlanNotFound() {
        // Edge Case: User tries to update a plan ID that doesn't exist
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("Plan not found", HttpStatus.NOT_FOUND);
        when(dietPlanService.updateDietPlanDetails(anyLong(), any(UpdateMealPlanDetailsRequest.class)))
                .thenReturn(serviceResponse);

        ResponseEntity<Object> response = dietPlanController.updateDietPlanDetails(999L, updateRequest);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
    }

    // --- getDietPlanDetails Tests ---

    @Test
    void getDietPlanDetails_Success() {
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("PlanDetails", HttpStatus.OK);
        when(dietPlanService.getDietPlanDetails(1L)).thenReturn(serviceResponse);

        ResponseEntity<Object> response = dietPlanController.getDietPlanDetails(1L);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
    }
}