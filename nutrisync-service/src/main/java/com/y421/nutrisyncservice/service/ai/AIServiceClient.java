package com.y421.nutrisyncservice.service.ai;

import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.request.dietPlan.MealPlanRequestDTO;
import com.y421.nutrisyncservice.request.impactSimulation.ImpactSimulationRequestDTO;
import com.y421.nutrisyncservice.response.dietPlan.DietPlanDetailedDTO;
import com.y421.nutrisyncservice.response.dietPlan.MealPlanResponseDTO;
import com.y421.nutrisyncservice.request.meal.MealLogRiskRequestDTO;
import com.y421.nutrisyncservice.response.riskPredictor.AIRiskPredictorResDTO;
import com.y421.nutrisyncservice.response.impactSimulation.ImpactSimulationResponseDTO;
import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import java.time.Duration;

@Service
public class AIServiceClient {

    private final RestTemplate restTemplate;
    private final Bucket rateLimitBucket;

    @Value("${python-service-url}")
    private String baseUrl;

    public AIServiceClient(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
        int rpm = 4; // 5 Requests per minute
        int rpd = 19; // 20 Requests per day

        // Gemini 2.5 Flash Free Tier Strict Limits
        Bandwidth minuteLimit = Bandwidth.builder()
                .capacity(rpm)
                .refillGreedy(rpm, Duration.ofMinutes(1))
                .build();

        Bandwidth dailyLimit = Bandwidth.builder()
                .capacity(rpd)
                .refillGreedy(rpd, Duration.ofDays(1))
                .build();

        // Build the bucket with BOTH limits applied simultaneously
        this.rateLimitBucket = Bucket.builder()
                .addLimit(minuteLimit)
                .addLimit(dailyLimit)
                .build();
    }

    private void enforceRateLimit() {
        if (!rateLimitBucket.tryConsume(1)) {
            throw new ResponseStatusException(
                    HttpStatus.TOO_MANY_REQUESTS, "AI Service rate limit exceeded, Please try again later"
            );
        }
    }

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
        enforceRateLimit(); // Check limit before processing

        String url = baseUrl + "/generate-meal-plan";
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

        HttpEntity<MealPlanRequestDTO> requestEntity = new HttpEntity<>(requestPayload, headers);

        try {
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

    public ImpactSimulationResponseDTO simulateHealthImpact(NutrisyncUser user, int months, DietPlanDetailedDTO dietPlan) {
        enforceRateLimit(); // Check limit before processing

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
                .dietPlan(dietPlan)
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

    public AIRiskPredictorResDTO predictRisk(MealLogRiskRequestDTO requestPayload) {
        enforceRateLimit(); // Check limit before processing

        try {
            // 1. Prepare the headers
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            // 2. Prepare header and payload
            HttpEntity<MealLogRiskRequestDTO> requestEntity = new HttpEntity<>(requestPayload, headers);

            // 3. Call the Python API
            ResponseEntity<AIRiskPredictorResDTO> response = restTemplate.postForEntity(baseUrl + "/risk-prediction", requestEntity, AIRiskPredictorResDTO.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                return response.getBody();
            } else {
                throw new RuntimeException("AI Service Error: " + response.getStatusCode());
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
  
}