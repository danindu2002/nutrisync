package com.y421.nutrisyncservice.service.mealLog;

import com.y421.nutrisyncservice.request.meal.MealLogRequestDTO;
import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDate;

public interface MealLogService {
    ResponseEntity<Object> identifyFood(MultipartFile image);
    ResponseEntity<Object> saveMealLog(MealLogRequestDTO dto, MultipartFile image) throws IOException;
    ResponseEntity<Object> getDailyLogs(Long userId, LocalDate date);
    ResponseEntity<Object> deleteLog(Long logId);
}