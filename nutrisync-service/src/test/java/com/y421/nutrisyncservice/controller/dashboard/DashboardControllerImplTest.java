package com.y421.nutrisyncservice.controller.dashboard;

import com.y421.nutrisyncservice.service.dashboard.DashboardService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class DashboardControllerImplTest {

    @Mock
    private DashboardService dashboardService;

    @InjectMocks
    private DashboardControllerImpl dashboardController;

    @Test
    void getCaloriesChart_Success() {
        // Arrange
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("chartData", HttpStatus.OK);
        when(dashboardService.getCaloriesChart(anyLong(), anyString())).thenReturn(serviceResponse);

        // Act
        ResponseEntity<Object> response = dashboardController.getCaloriesChart(1L, "week");

        // Assert
        assertNotNull(response);
        assertEquals(HttpStatus.OK, response.getStatusCode());
    }

    @Test
    void getCaloriesChart_ServiceReturnsError_PassesErrorStatus() {
        // Arrange
        // Simulate the service rejecting the request (e.g., user not found)
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("User not found", HttpStatus.NOT_FOUND);
        when(dashboardService.getCaloriesChart(1L, "week")).thenReturn(serviceResponse);

        // Act
        ResponseEntity<Object> response = dashboardController.getCaloriesChart(1L, "week");

        // Assert
        // The controller should map the NOT_FOUND status back to the client
        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
    }

    @Test
    void getCaloriesChart_ExceptionThrown_ReturnsBadRequest() {
        // Arrange
        when(dashboardService.getCaloriesChart(anyLong(), anyString())).thenThrow(new RuntimeException("Unexpected error"));

        // Act
        ResponseEntity<Object> response = dashboardController.getCaloriesChart(1L, "week");

        // Assert
        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
    }

    @Test
    void getNutritionChart_Success() {
        // Arrange
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("nutritionData", HttpStatus.OK);
        when(dashboardService.getNutritionChart(1L, "month")).thenReturn(serviceResponse);

        // Act
        ResponseEntity<Object> response = dashboardController.getNutritionChart(1L, "month");

        // Assert
        assertEquals(HttpStatus.OK, response.getStatusCode());
    }

    @Test
    void getCaloriesChart_DayRange_Success() {
    // Arrange
    ResponseEntity<Object> serviceResponse =
            new ResponseEntity<>("dayData", HttpStatus.OK);

    when(dashboardService.getCaloriesChart(1L, "day"))
            .thenReturn(serviceResponse);

    // Act
    ResponseEntity<Object> response =
            dashboardController.getCaloriesChart(1L, "day");

    // Assert
    assertNotNull(response);
    assertEquals(HttpStatus.OK, response.getStatusCode());
    }

    @Test
    void getNutritionChart_ExceptionThrown_ReturnsBadRequest() {
    // Arrange
    when(dashboardService.getNutritionChart(anyLong(), anyString()))
            .thenThrow(new RuntimeException("Error"));

    // Act
    ResponseEntity<Object> response =
            dashboardController.getNutritionChart(1L, "week");

    // Assert
    assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
    }



}