package com.y421.nutrisyncservice.service.riskPredictor;

import org.springframework.http.ResponseEntity;

public interface RiskPredictorService {
    ResponseEntity<Object> predictRisk(Long userId);
}