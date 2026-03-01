package com.y421.nutrisyncservice.util;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.springframework.stereotype.Component;

import java.util.Base64;
import java.util.Collections;
import java.util.Map;
@Component
public class JwtDecoder {

    public Map<String, Object> getPayload(String accessToken) {
        try {
            Base64.Decoder decoder = Base64.getUrlDecoder();
            String[] chunks = accessToken.split("\\.");

            String payload = new String(decoder.decode(chunks[1]));

            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.configure(SerializationFeature.FAIL_ON_EMPTY_BEANS, false);

            return objectMapper.readValue(payload, new TypeReference<>() {
            });
        } catch (Exception e) {
            return Collections.emptyMap();
        }
    }

    public JwtClaimsDTO getPayloadKeycloak(String accessToken) {
        try {
            Base64.Decoder decoder = Base64.getUrlDecoder();
            String[] chunks = accessToken.split("\\.");

            if (chunks.length < 2) {
                throw new IllegalArgumentException("Invalid JWT token format");
            }

            String payload = new String(decoder.decode(chunks[1]));

            ObjectMapper objectMapper = new ObjectMapper();
            return objectMapper.readValue(payload, JwtClaimsDTO.class);
        } catch (Exception e) {
            throw new RuntimeException("Failed to parse JWT token", e);
        }
    }

}
