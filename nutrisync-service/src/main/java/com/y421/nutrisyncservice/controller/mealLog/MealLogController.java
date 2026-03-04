package com.y421.nutrisyncservice.controller.mealLog;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

@RequestMapping("/api/v1/meal")
public interface MealLogController {

    @PostMapping(value = "/identify", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    ResponseEntity<Object> identifyMeal(
        @RequestParam("image") MultipartFile image,
        @RequestParam("userId") Long userId,
        @RequestParam("mealType") String mealType
    );
}