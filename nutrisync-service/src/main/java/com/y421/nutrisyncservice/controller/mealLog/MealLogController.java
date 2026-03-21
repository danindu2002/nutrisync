package com.y421.nutrisyncservice.controller.mealLog;

import com.y421.nutrisyncservice.request.meal.MealLogRequestDTO;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDate;

@RequestMapping("/api/v1/meal")
public interface MealLogController {

    @PostMapping(value = "/identify", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    ResponseEntity<Object> identifyMeal(@RequestParam("image") MultipartFile image);

    @PostMapping(value = "/log", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    ResponseEntity<Object> logMeal(
            @RequestPart("data") String dataString,
            @RequestPart(value = "image", required = false) MultipartFile image) throws IOException;

    @GetMapping("/getLogs")
    ResponseEntity<Object> getLogs(
            @RequestParam("userId") Long userId,
            @RequestParam("date") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date);

    @DeleteMapping("/delete/{logId}")
    ResponseEntity<Object> deleteLog(@PathVariable("logId") Long logId);

}