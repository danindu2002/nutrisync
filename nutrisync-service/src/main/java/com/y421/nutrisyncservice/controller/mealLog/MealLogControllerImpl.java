package com.y421.nutrisyncservice.controller.mealLog;

import com.y421.nutrisyncservice.service.mealLog.MealLogService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import static com.y421.nutrisyncservice.util.ResponseHandler.generateResponse;

@RestController
@RequiredArgsConstructor
public class MealLogControllerImpl implements MealLogController {

    private final MealLogService mealService;

    @Override
    public ResponseEntity<Object> identifyMeal(MultipartFile image, Long userId, String mealType) {
        try {
            ResponseEntity<Object> response = mealService.identifyAndLogMeal(image, userId, mealType);
            if (response.getStatusCode().isSameCodeAs(HttpStatus.OK)) {
                return generateResponse("Meal recognized Successfully", HttpStatus.OK, response.getBody());
            } else {
                return generateResponse((String) response.getBody(), (HttpStatus) response.getStatusCode(), null);
            }
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }
}