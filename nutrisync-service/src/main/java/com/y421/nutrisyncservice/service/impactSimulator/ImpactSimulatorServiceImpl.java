package com.y421.nutrisyncservice.service.impactSimulator;

import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.repository.dietPlan.MealPlanRepository;
import com.y421.nutrisyncservice.repository.nutrisyncUser.NutrisyncUserRepository;
import com.y421.nutrisyncservice.response.impactSimulation.ImpactSimulationResponseDTO;
import com.y421.nutrisyncservice.service.ai.AIServiceClient;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import java.util.*;

@Service
@RequiredArgsConstructor
public class ImpactSimulatorServiceImpl implements ImpactSimulatorService {

    private final NutrisyncUserRepository userRepository;
    private final MealPlanRepository mealPlanRepository;
    private final AIServiceClient aiServiceClient;

    @Override
    public ResponseEntity<Object> getUserBMI(Long userId) {
        try {
            Optional<NutrisyncUser> user = userRepository.findById(userId);
            if (user.isEmpty()) {
                return new ResponseEntity<>("User Not Found", HttpStatus.NOT_FOUND);
            }
            if (user.get().getBmi() == null) {
                return new ResponseEntity<>("BMI Not Found", HttpStatus.NOT_FOUND);
            }
            return new ResponseEntity<>(user.get().getBmi(), HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Error Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    public ResponseEntity<Object> simulateImpact(Long userId, Integer months) {
        try {
            Optional<NutrisyncUser> user = userRepository.findById(userId);//ToDo-> add isDeleted validation
            if (user.isEmpty()) {
                return new ResponseEntity<>("User Not Found", HttpStatus.NOT_FOUND);
            }

            ImpactSimulationResponseDTO res = aiServiceClient.simulateHealthImpact(user.get(), months);
            if (res == null) {
                return new ResponseEntity<>("Error Simulating Impact", HttpStatus.CONFLICT);
            }
            return new ResponseEntity<>(res, HttpStatus.OK);
        } catch (ResponseStatusException e) {
            // This catches the 429 Too Many Requests from the Rate Limiter
            return new ResponseEntity<>(e.getReason(), e.getStatusCode());
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Error Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
