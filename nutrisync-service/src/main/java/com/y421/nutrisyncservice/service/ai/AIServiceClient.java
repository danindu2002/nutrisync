package com.y421.nutrisyncservice.service.ai;

import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.request.dietPlan.MealPlanRequestDTO;
import com.y421.nutrisyncservice.request.impactSimulation.ImpactSimulationRequestDTO;
import com.y421.nutrisyncservice.response.dietPlan.MealPlanResponseDTO;
import com.y421.nutrisyncservice.response.impactSimulation.ImpactSimulationResponseDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

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

    public ImpactSimulationResponseDTO simulateHealthImpact(NutrisyncUser user, int months) {
        String url = baseUrl + "/simulate-impact";

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        // Create a request DTO that includes current stats + duration
        ImpactSimulationRequestDTO requestPayload = ImpactSimulationRequestDTO.builder()
                .age(user.getAge())
                .gender(user.getGender())
                .weightKg(user.getWeightKg())
                .heightCm(user.getHeightCm())
                .bmi(user.getBmi())
                .dailyCalorieGoal(user.getDailyCalorieGoal())
                .months(months)
                .build();

        HttpEntity<ImpactSimulationRequestDTO> requestEntity = new HttpEntity<>(requestPayload, headers);

        try {
            ResponseEntity<ImpactSimulationResponseDTO> response = restTemplate.postForEntity(
                    url,
                    requestEntity,
                    ImpactSimulationResponseDTO.class
            );

            if (response.getStatusCode() == HttpStatus.OK) {
                return response.getBody();
            } else {
                throw new RuntimeException("AI Service failed to simulate impact");
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}