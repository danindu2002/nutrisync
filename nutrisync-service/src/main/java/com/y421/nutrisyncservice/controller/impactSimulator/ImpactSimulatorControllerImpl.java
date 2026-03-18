package com.y421.nutrisyncservice.controller.impactSimulator;

import com.y421.nutrisyncservice.controller.dietPlan.DietPlanController;
import com.y421.nutrisyncservice.request.dietPlan.SaveMealPlanRequest;
import com.y421.nutrisyncservice.request.dietPlan.UpdateMealPlanDetailsRequest;
import com.y421.nutrisyncservice.service.dietPlan.DietPlanService;
import com.y421.nutrisyncservice.service.impactSimulator.ImpactSimulatorService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

import static com.y421.nutrisyncservice.util.ResponseHandler.generateResponse;

@RestController
@RequiredArgsConstructor
public class ImpactSimulatorControllerImpl implements ImpactSimulatorController {

    private final ImpactSimulatorService impactSimulatorService;

    @Override
    public ResponseEntity<Object> getUserBMI(Long userId) {
        try {
            ResponseEntity<Object> response = impactSimulatorService.getUserBMI(userId);
            if (response.getStatusCode().isSameCodeAs(HttpStatus.OK)) {
                return generateResponse("BMI Retrieved Successfully", HttpStatus.OK, response.getBody());
            } else {
                return generateResponse((String) response.getBody(), (HttpStatus) response.getStatusCode(), null);
            }
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }

    @Override
    public ResponseEntity<Object> simulateImpact(Long userId, Integer months) {
        try {
            ResponseEntity<Object> response = impactSimulatorService.simulateImpact(userId, months);
            if (response.getStatusCode().isSameCodeAs(HttpStatus.OK)) {
                return generateResponse("Health Impact Simulated Successfully", HttpStatus.OK, response.getBody());
            } else {
                return generateResponse((String) response.getBody(), (HttpStatus) response.getStatusCode(), null);
            }
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }
}
