package com.y421.nutrisyncservice.service.dashboard;

import org.springframework.http.ResponseEntity;

public interface DashboardService {
    ResponseEntity<Object> getCaloriesChart(Long userId, String range);
}