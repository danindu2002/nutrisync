package com.y421.nutrisyncservice.controller.dashboard;

import com.y421.nutrisyncservice.service.dashboard.DashboardService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

import static com.y421.nutrisyncservice.util.ResponseHandler.generateResponse;

@RestController
@RequiredArgsConstructor
public class DashboardControllerImpl implements DashboardController {

    private final DashboardService dashboardService;

    @Override
    public ResponseEntity<Object> getCaloriesChart(Long userId, String range) {
        try {
            ResponseEntity<Object> response = dashboardService.getCaloriesChart(userId, range);

            if (response.getStatusCode().isSameCodeAs(HttpStatus.OK)) {
                return generateResponse("Calories chart fetched successfully", HttpStatus.OK, response.getBody());
            } else {
                return generateResponse((String) response.getBody(), (HttpStatus) response.getStatusCode(), null);
            }
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }

    @Override
    public ResponseEntity<Object> getNutritionChart(Long userId, String range) {
        try {
            ResponseEntity<Object> response = dashboardService.getNutritionChart(userId, range);

            if (response.getStatusCode().isSameCodeAs(HttpStatus.OK)) {
                return generateResponse("Nutrition chart fetched successfully", HttpStatus.OK, response.getBody());
            } else {
                return generateResponse((String) response.getBody(), (HttpStatus) response.getStatusCode(), null);
            }
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }
}