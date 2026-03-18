package com.y421.nutrisyncservice.controller.dashboard;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@RequestMapping("/api/v1/dashboard")
public interface DashboardController {

    @GetMapping("/calories")
    ResponseEntity<Object> getCaloriesChart(
            @RequestParam("userId") Long userId,
            @RequestParam("range") String range
    );
    @GetMapping("/nutrition")
    ResponseEntity<Object> getNutritionChart(
            @RequestParam("userId") Long userId,
            @RequestParam("range") String range
    );
}