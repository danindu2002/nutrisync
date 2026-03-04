package com.y421.nutrisyncservice.controller.mealLog;

import com.y421.nutrisyncservice.request.meal.MealLogRequestDTO;
import com.y421.nutrisyncservice.service.mealLog.MealLogService;
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
public class MealLogControllerImpl implements MealLogController {

    private final MealLogService mealService;

    @Override
    public ResponseEntity<Object> identifyMeal(MultipartFile image) {
        try {
            ResponseEntity<Object> response = mealService.identifyFood(image);
            if (response.getStatusCode().isSameCodeAs(HttpStatus.OK)) {
                return generateResponse("Meal Recognized Successfully", HttpStatus.OK, response.getBody());
            } else {
                return generateResponse((String) response.getBody(), (HttpStatus) response.getStatusCode(), null);
            }
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }

    @Override
    public ResponseEntity<Object> logMeal(MealLogRequestDTO dto, MultipartFile image) throws IOException {
        try {
            ResponseEntity<Object> response = mealService.saveMealLog(dto, image);
            if (response.getStatusCode().isSameCodeAs(HttpStatus.OK)) {
                return generateResponse("Meal Logged Successfully", HttpStatus.OK, response.getBody());
            } else {
                return generateResponse((String) response.getBody(), (HttpStatus) response.getStatusCode(), null);
            }
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }

    @Override
    public ResponseEntity<Object> getLogs(Long userId, LocalDate date) {
        try {
            ResponseEntity<Object> response = mealService.getDailyLogs(userId, date);
            if (response.getStatusCode().isSameCodeAs(HttpStatus.OK)) {
                return generateResponse("Meal Logs Fetched Successfully", HttpStatus.OK, response.getBody());
            } else {
                return generateResponse((String) response.getBody(), (HttpStatus) response.getStatusCode(), null);
            }
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }

    @Override
    public ResponseEntity<Object> deleteLog(Long logId) {
        try {
            ResponseEntity<Object> response = mealService.deleteLog(logId);
            if (response.getStatusCode().isSameCodeAs(HttpStatus.OK)) {
                return generateResponse("Log Deleted Successfully", HttpStatus.OK, response.getBody());
            } else {
                return generateResponse((String) response.getBody(), (HttpStatus) response.getStatusCode(), null);
            }
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }
}