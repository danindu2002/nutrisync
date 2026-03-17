package com.y421.nutrisyncservice.service.ai;

import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.request.dietPlan.MealPlanRequestDTO;
import com.y421.nutrisyncservice.response.dietPlan.MealPlanResponseDTO;
import com.y421.nutrisyncservice.request.meal.MealLogRiskRequestDTO;
import com.y421.nutrisyncservice.response.riskPredictor.RiskPredictDTO;
import com.y421.nutrisyncservice.response.riskPredictor.RiskPredictorResponseDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

import java.util.Arrays;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AIServiceClient {

    private final RestTemplate restTemplate;

    @Value("${python-service-url}")
    private String baseUrl;

    public String predictFood(MultipartFile image) {
        try {
            // 1. Prepare the headers
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);

            // 2. Prepare the request body (Multipart)
            MultiValueMap<String, Object> body = new LinkedMultiValueMap<>();
            body.add("file", image.getResource());

            HttpEntity<MultiValueMap<String, Object>> requestEntity = new HttpEntity<>(body, headers);

            // 3. Call the Python API
            String url = baseUrl + "/predict";
            ResponseEntity<String> response = restTemplate.postForEntity(url, requestEntity, String.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                return response.getBody();
            } else {
                throw new RuntimeException("AI Service Error: " + response.getStatusCode());
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "unknown";
        }
    }

    public MealPlanResponseDTO generateMealPlanForUser(NutrisyncUser user) {
        String url = baseUrl + "/generate-meal-plan";

        // 1. Prepare headers for JSON
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        MealPlanRequestDTO requestPayload = MealPlanRequestDTO.builder()
                .age(user.getAge())
                .gender(user.getGender())
                .weightKg(user.getWeightKg())
                .heightCm(user.getHeightCm())
                .activityLevel(user.getActivityLevel())
                .fitnessGoal(user.getFitnessGoal())
                .dailyCalorieGoal(user.getDailyCalorieGoal())
                .allergies(user.getAllergies())
                .dietaryPreferences(user.getDietaryPreferences())
                .build();

        // 2. Send the clean DTO instead of the raw user entity
        HttpEntity<MealPlanRequestDTO> requestEntity = new HttpEntity<>(requestPayload, headers);

        try {
            // 3. Call the Python API and map the response automatically to the DTO
            ResponseEntity<MealPlanResponseDTO> response = restTemplate.postForEntity(
                    url,
                    requestEntity,
                    MealPlanResponseDTO.class
            );

            if (response.getStatusCode() == HttpStatus.OK) {
                return response.getBody();
            } else {
                throw new RuntimeException("AI Service failed to generate plan");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public RiskPredictorResponseDTO predictRisk(MealLogRiskRequestDTO requestPayload) {
        try {
            // 1. Prepare the headers
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            // 2. Prepare header and payload
            HttpEntity<MealLogRiskRequestDTO> requestEntity = new HttpEntity<>(requestPayload, headers);

            // 3. Call the Python API
            ResponseEntity<RiskPredictDTO[]> response = restTemplate.postForEntity(baseUrl + "/risk-prediction", requestEntity, RiskPredictDTO[].class);

            System.out.println(response.getBody());
            if (response.getStatusCode() == HttpStatus.OK) {
                List<RiskPredictDTO> riskList = Arrays.asList(response.getBody());

                RiskPredictorResponseDTO wrapper = new RiskPredictorResponseDTO();
                wrapper.setRiskPredictionList(riskList);

                return wrapper;
            } else {
                throw new RuntimeException("AI Service Error: " + response.getStatusCode());
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}