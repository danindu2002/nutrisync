package com.y421.nutrisyncservice.controller.mealLog;

import com.y421.nutrisyncservice.request.meal.MealLogRequestDTO;
import com.y421.nutrisyncservice.service.mealLog.MealLogService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class MealLogControllerImplTest {

    @Mock
    private MealLogService mealService; // Matches the variable name in your Controller

    @InjectMocks
    private MealLogControllerImpl mealLogController;

    private MockMultipartFile mockImage;

    @BeforeEach
    void setUp() {
        mockImage = new MockMultipartFile("image", "food.png", "image/png", "dummy image data".getBytes());
    }

    // identifyMeal() Tests
    @Test
    void identifyMeal_Success() {
        // Uses identifyFood() as defined in your service
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("Identified Food", HttpStatus.OK);
        when(mealService.identifyFood(any(MultipartFile.class))).thenReturn(serviceResponse);

        ResponseEntity<Object> response = mealLogController.identifyMeal(mockImage);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertNotNull(response.getBody());
    }

    @Test
    void identifyMeal_ServiceReturnsError_PassesErrorStatus() {
        // E.g., AI Service rate limit or failure
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("AI Service Failed", HttpStatus.FAILED_DEPENDENCY);
        when(mealService.identifyFood(any(MultipartFile.class))).thenReturn(serviceResponse);

        ResponseEntity<Object> response = mealLogController.identifyMeal(mockImage);

        assertEquals(HttpStatus.FAILED_DEPENDENCY, response.getStatusCode());
    }

    @Test
    void identifyMeal_Exception_ReturnsBadRequest() {
        when(mealService.identifyFood(any(MultipartFile.class))).thenThrow(new RuntimeException("Unexpected exception"));

        ResponseEntity<Object> response = mealLogController.identifyMeal(mockImage);

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
    }

    // logMeal() Tests
    @Test
    void logMeal_Success() throws Exception {
        // Valid JSON string that the ObjectMapper can parse
        String validJsonString = "{ \"userId\": 1, \"foodName\": \"Apple\", \"mealTime\": \"BREAKFAST\" }";
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("Meal Logged", HttpStatus.OK);

        // Controller parses the string into a DTO before passing to service
        when(mealService.saveMealLog(any(MealLogRequestDTO.class), any(MultipartFile.class))).thenReturn(serviceResponse);

        ResponseEntity<Object> response = mealLogController.logMeal(validJsonString, mockImage);

        assertEquals(HttpStatus.OK, response.getStatusCode());
    }

    @Test
    void logMeal_InvalidJsonString_ReturnsBadRequest() throws Exception {
        // Edge Case: Frontend sends malformed JSON. ObjectMapper will throw JsonProcessingException.
        // The catch block in your controller should catch it and return a 400 Bad Request.
        String invalidJsonString = "This is not valid JSON";

        // We don't need to mock mealService.logMeal because the code will break at ObjectMapper.readValue()
        ResponseEntity<Object> response = mealLogController.logMeal(invalidJsonString, mockImage);

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
    }

    @Test
    void logMeal_ServiceReturnsError_PassesErrorStatus() throws Exception {
        String validJsonString = "{ \"userId\": 1 }";
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("User Not Found", HttpStatus.NOT_FOUND);
        when(mealService.saveMealLog(any(MealLogRequestDTO.class), any(MultipartFile.class))).thenReturn(serviceResponse);

        ResponseEntity<Object> response = mealLogController.logMeal(validJsonString, mockImage);

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
    }

    // getLogs() Tests
    @Test
    void getLogs_Success() {
        // Uses getDailyLogs() as defined in your service
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("LogsData", HttpStatus.OK);
        when(mealService.getDailyLogs(anyLong(), any(LocalDate.class))).thenReturn(serviceResponse);

        ResponseEntity<Object> response = mealLogController.getLogs(1L, LocalDate.now());

        assertEquals(HttpStatus.OK, response.getStatusCode());
    }

    @Test
    void getLogs_NoLogsFound_PassesErrorStatus() {
        // E.g., Service returns 404 or empty state
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("No logs for today", HttpStatus.NOT_FOUND);
        when(mealService.getDailyLogs(anyLong(), any(LocalDate.class))).thenReturn(serviceResponse);

        ResponseEntity<Object> response = mealLogController.getLogs(1L, LocalDate.now());

        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
    }

    @Test
    void getLogs_Exception_ReturnsBadRequest() {
        when(mealService.getDailyLogs(anyLong(), any(LocalDate.class))).thenThrow(new IllegalArgumentException("Invalid date"));

        ResponseEntity<Object> response = mealLogController.getLogs(1L, LocalDate.now());

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
    }

    // deleteLog() Tests
    @Test
    void deleteLog_Success() {
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("Log Deleted Successfully", HttpStatus.OK);
        when(mealService.deleteLog(1L)).thenReturn(serviceResponse);

        ResponseEntity<Object> response = mealLogController.deleteLog(1L);

        assertEquals(HttpStatus.OK, response.getStatusCode());
    }

    @Test
    void deleteLog_EdgeCase_NotFound() {
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("Meal Not Found", HttpStatus.NOT_FOUND);
        when(mealService.deleteLog(99L)).thenReturn(serviceResponse);

        ResponseEntity<Object> response = mealLogController.deleteLog(99L);

        // Controller correctly passes back the 404 from the service
        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
    }

    @Test
    void deleteLog_Exception_ReturnsBadRequest() {
        when(mealService.deleteLog(anyLong())).thenThrow(new RuntimeException("Database offline"));

        ResponseEntity<Object> response = mealLogController.deleteLog(1L);

        assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
    }

    @Test
    void identifyMeal_EmptyFile() {
    // Arrange
    MockMultipartFile emptyFile =
            new MockMultipartFile("image", "", "image/png", new byte[0]);

    ResponseEntity<Object> serviceResponse =
            new ResponseEntity<>("Invalid image", HttpStatus.BAD_REQUEST);

    when(mealService.identifyFood(any(MultipartFile.class)))
            .thenReturn(serviceResponse);

    // Act
    ResponseEntity<Object> response =
            mealLogController.identifyMeal(emptyFile);

    // Assert
    assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
    }

    @Test
    void logMeal_WithoutImage_Success() throws Exception {
    // Arrange
    String validJsonString = "{ \"userId\": 1, \"foodName\": \"Rice\", \"mealTime\": \"LUNCH\" }";

    ResponseEntity<Object> serviceResponse =
            new ResponseEntity<>("Meal Logged", HttpStatus.OK);

    when(mealService.saveMealLog(any(MealLogRequestDTO.class), any()))
            .thenReturn(serviceResponse);

    // Act
    ResponseEntity<Object> response =
            mealLogController.logMeal(validJsonString, null);

    // Assert
    assertEquals(HttpStatus.OK, response.getStatusCode());
    }

    @Test
    void getLogs_InvalidDateFormat() {
    // This simulates controller-level validation failure scenario
    when(mealService.getDailyLogs(anyLong(), any(LocalDate.class)))
            .thenThrow(new RuntimeException("Invalid date format"));

    ResponseEntity<Object> response =
            mealLogController.getLogs(1L, LocalDate.now());

    assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
    }

}