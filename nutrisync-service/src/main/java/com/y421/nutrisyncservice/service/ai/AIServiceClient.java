package com.y421.nutrisyncservice.service.ai;

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

//    private final String PYTHON_SERVICE_URL = "http://127.0.0.1:5000/predict";

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
            ResponseEntity<String> response = restTemplate.postForEntity(baseUrl + "/predict", requestEntity, String.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                return response.getBody(); // Returns food name like "pizza"
            } else {
                throw new RuntimeException("AI Service Error: " + response.getStatusCode());
            }
        } catch (Exception e) {
            e.printStackTrace();
    return "unknown.";
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