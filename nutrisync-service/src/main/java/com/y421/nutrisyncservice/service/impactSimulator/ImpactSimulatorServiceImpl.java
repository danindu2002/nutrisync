package com.y421.nutrisyncservice.service.impactSimulator;

import com.y421.nutrisyncservice.entity.dietPlan.DailyPlan;
import com.y421.nutrisyncservice.entity.dietPlan.MealPlan;
import com.y421.nutrisyncservice.entity.dietPlan.PlannedMeal;
import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.repository.dietPlan.MealPlanRepository;
import com.y421.nutrisyncservice.repository.nutrisyncUser.NutrisyncUserRepository;
import com.y421.nutrisyncservice.response.dietPlan.DailyPlanDTO;
import com.y421.nutrisyncservice.response.dietPlan.DietPlanDetailedDTO;
import com.y421.nutrisyncservice.response.dietPlan.PlannedMealDTO;
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
            // Get active diet plan
            Optional<MealPlan> latestPlan =
                    mealPlanRepository.findTopByUser_UserIdAndIsActiveTrueOrderByStartDateDesc(userId);

            if (latestPlan.isEmpty()) {
                return new ResponseEntity<>("No Active Diet Plan Found", HttpStatus.NOT_FOUND);
            }
            MealPlan plan = latestPlan.get();

            // Map the top-level Plan Details
            DietPlanDetailedDTO dto = new DietPlanDetailedDTO();
            dto.setPlanId(plan.getPlanId());
            dto.setDietPlanName(plan.getDietPlanName());
            dto.setDietPlanDescription(plan.getDietPlanDescription());
            dto.setDietPlanImage(plan.getDietPlanImage());
            dto.setStartDate(plan.getStartDate());
            dto.setEndDate(plan.getEndDate());

            // Loop through the Days
            for (DailyPlan dailyPlan : plan.getDailyPlans()) {
                DailyPlanDTO dayDto = new DailyPlanDTO();
                dayDto.setDay(dailyPlan.getDayOfWeek());

                // Loop through the Meals for that Day
                for (PlannedMeal meal : dailyPlan.getPlannedMeals()) {
                    PlannedMealDTO mealDto = new PlannedMealDTO();
                    mealDto.setMealId(meal.getPlannedMealId());
                    mealDto.setMealType(meal.getMealType().name()); // Converts Enum to String
                    mealDto.setRecipeName(meal.getRecipeName());
                    mealDto.setImageSearchTerm(meal.getImageSearchTerm());
                    mealDto.setMealImageUrl(meal.getMealImageUrl());
                    mealDto.setPrepTimeMin(meal.getPrepTimeMin());
                    mealDto.setCalories(meal.getCalories());
                    mealDto.setProteinG(meal.getProteinG());
                    mealDto.setCarbsG(meal.getCarbsG());
                    mealDto.setFatG(meal.getFatG());

                    dayDto.getMeals().add(mealDto);
                }
                dto.getWeeklyPlan().add(dayDto);
            }

            ImpactSimulationResponseDTO res = aiServiceClient.simulateHealthImpact(user.get(), months, dto);
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
