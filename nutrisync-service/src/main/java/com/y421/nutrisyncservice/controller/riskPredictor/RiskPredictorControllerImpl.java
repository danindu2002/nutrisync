package com.y421.nutrisyncservice.controller.riskPredictor;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.y421.nutrisyncservice.controller.mealLog.MealLogController;
import com.y421.nutrisyncservice.request.meal.MealLogRequestDTO;
import com.y421.nutrisyncservice.service.mealLog.MealLogService;
import com.y421.nutrisyncservice.service.riskPredictor.RiskPredictorService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDate;

import static com.y421.nutrisyncservice.util.ResponseHandler.generateResponse;

@RestController
@RequiredArgsConstructor
public class RiskPredictorControllerImpl implements RiskPredictorController {

    private final RiskPredictorService riskPredictorService;

    @Override
    public ResponseEntity<Object> predictRisk(Long userId) {
        try {
            ResponseEntity<Object> response = riskPredictorService.predictRisk(userId);
            if (response.getStatusCode().isSameCodeAs(HttpStatus.OK)) {
                return generateResponse("Risk Predicted Successfully", HttpStatus.OK, response.getBody());
            } else {
                return generateResponse((String) response.getBody(), (HttpStatus) response.getStatusCode(), null);
            }
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }
}