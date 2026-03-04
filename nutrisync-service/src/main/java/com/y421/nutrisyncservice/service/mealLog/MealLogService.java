package com.y421.nutrisyncservice.service.mealLog;

import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartFile;

public interface MealLogService {
    ResponseEntity<Object> identifyAndLogMeal(MultipartFile image, Long userId, String mealType);
}