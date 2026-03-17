package com.y421.nutrisyncservice.controller.dietPlan;

import com.y421.nutrisyncservice.request.dietPlan.SaveMealPlanRequest;
import com.y421.nutrisyncservice.request.dietPlan.UpdateMealPlanDetailsRequest;
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
    public ResponseEntity<Object> generateMealPlanPreview(Long userId) {
        try {
            ResponseEntity<Object> response = dietPlanService.generateMealPlanPreview(userId);
            if (response.getStatusCode().isSameCodeAs(HttpStatus.OK)) {
                return generateResponse("Meal Plan Created Successfully", HttpStatus.OK, response.getBody());
            } else {
                return generateResponse((String) response.getBody(), (HttpStatus) response.getStatusCode(), null);
            }
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }

    @Override
    public ResponseEntity<Object> saveMealPlan(SaveMealPlanRequest request) {
        try {
            ResponseEntity<Object> response = dietPlanService.saveMealPlan(request);
            if (response.getStatusCode().isSameCodeAs(HttpStatus.OK)) {
                return generateResponse("Meal Plan Saved Successfully", HttpStatus.OK, response.getBody());
            } else {
                return generateResponse((String) response.getBody(), (HttpStatus) response.getStatusCode(), null);
            }
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }

    @Override
    public ResponseEntity<Object> getAllDietPlansByUser(Long userId) {
        try {
            ResponseEntity<Object> response = dietPlanService.getAllDietPlansByUser(userId);
            if (response.getStatusCode().isSameCodeAs(HttpStatus.OK)) {
                return generateResponse("Meal Plans Fetched Successfully", HttpStatus.OK, response.getBody());
            } else {
                return generateResponse((String) response.getBody(), (HttpStatus) response.getStatusCode(), null);
            }
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }

    @Override
    public ResponseEntity<Object> deleteDietPlan(Long planId) {
        try {
            ResponseEntity<Object> response = dietPlanService.deleteDietPlan(planId);
            if (response.getStatusCode().isSameCodeAs(HttpStatus.OK)) {
                return generateResponse("Meal Plan Deleted Successfully", HttpStatus.OK, response.getBody());
            } else {
                return generateResponse((String) response.getBody(), (HttpStatus) response.getStatusCode(), null);
            }
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }

    @Override
    public ResponseEntity<Object> updateDietPlanDetails(Long planId, UpdateMealPlanDetailsRequest request) {
        try {
            ResponseEntity<Object> response = dietPlanService.updateDietPlanDetails(planId, request);
            if (response.getStatusCode().isSameCodeAs(HttpStatus.OK)) {
                return generateResponse("Plan Details Updated Successfully", HttpStatus.OK, response.getBody());
            } else {
                return generateResponse((String) response.getBody(), (HttpStatus) response.getStatusCode(), null);
            }
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }

    @Override
    public ResponseEntity<Object> getDietPlanDetails(Long planId) {
        try {
            ResponseEntity<Object> response = dietPlanService.getDietPlanDetails(planId);
            if (response.getStatusCode().isSameCodeAs(HttpStatus.OK)) {
                return generateResponse("Plan Details Fetched Successfully", HttpStatus.OK, response.getBody());
            } else {
                return generateResponse((String) response.getBody(), (HttpStatus) response.getStatusCode(), null);
            }
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }
}
