package com.y421.nutrisyncservice.controller.dietPlan;

import com.y421.nutrisyncservice.service.dietPlan.DietPlanService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

import static com.y421.nutrisyncservice.util.ResponseHandler.generateResponse;

@RestController
@RequiredArgsConstructor
public class DietPlanControllerImpl implements DietPlanController {

    private final DietPlanService dietPlanService;

    @Override
    public ResponseEntity<Object> createCustomMealPlan(Long userId) {
        try {
            ResponseEntity<Object> response = dietPlanService.createCustomMealPlan(userId);
            if (response.getStatusCode().isSameCodeAs(HttpStatus.OK)) {
                return generateResponse("Meal Plan Created Successfully", HttpStatus.OK, response.getBody());
            } else {
                return generateResponse((String) response.getBody(), (HttpStatus) response.getStatusCode(), null);
            }
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }
}
