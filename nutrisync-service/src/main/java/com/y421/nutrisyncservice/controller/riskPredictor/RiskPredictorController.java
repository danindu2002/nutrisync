package com.y421.nutrisyncservice.controller.riskPredictor;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequestMapping("/api/v1/risk-predictor")
public interface RiskPredictorController {

    @PostMapping("/predict-risk/{userId}")
    ResponseEntity<Object> predictRisk(@PathVariable("userId") Long userId, @RequestParam("years") Integer years);

}