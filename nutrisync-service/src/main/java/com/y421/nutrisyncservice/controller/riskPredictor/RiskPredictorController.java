package com.y421.nutrisyncservice.controller.riskPredictor;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDate;

@RequestMapping("/api/v1/risk-predictor")
public interface RiskPredictorController {

    @PostMapping("/predict-risk/{userId}")
    ResponseEntity<Object> predictRisk(@PathVariable("userId") Long userId);

}