package com.y421.nutrisyncservice.controller.riskPredictor;

import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDate;

@RequestMapping("/api/v1/riskPredictor")
public interface RiskPredictorController {

    @PostMapping("/predictRisk")
    ResponseEntity<Object> predictRisk(@RequestParam("userId") Long userId);

}