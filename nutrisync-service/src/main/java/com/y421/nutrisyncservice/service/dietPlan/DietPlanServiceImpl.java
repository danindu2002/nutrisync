package com.y421.nutrisyncservice.service.dietPlan;

import com.y421.nutrisyncservice.entity.dietPlan.DailyPlan;
import com.y421.nutrisyncservice.entity.dietPlan.MealPlan;
import com.y421.nutrisyncservice.entity.dietPlan.PlannedMeal;
import com.y421.nutrisyncservice.entity.mealLog.MealTime;
import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.repository.dietPlan.MealPlanRepository;
import com.y421.nutrisyncservice.repository.nutrisyncUser.NutrisyncUserRepository;
import com.y421.nutrisyncservice.request.dietPlan.MealPlanSummaryDTO;
import com.y421.nutrisyncservice.request.dietPlan.SaveMealPlanRequest;
import com.y421.nutrisyncservice.request.dietPlan.UpdateMealPlanDetailsRequest;
import com.y421.nutrisyncservice.response.dietPlan.DailyPlanDTO;
import com.y421.nutrisyncservice.response.dietPlan.DietPlanDetailedDTO;
import com.y421.nutrisyncservice.response.dietPlan.MealPlanResponseDTO;
import com.y421.nutrisyncservice.response.dietPlan.PlannedMealDTO;
import com.y421.nutrisyncservice.service.ai.AIServiceClient;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
@RequiredArgsConstructor
public class DietPlanServiceImpl implements DietPlanService {

    private final NutrisyncUserRepository userRepository;
    private final MealPlanRepository mealPlanRepository;
    private final AIServiceClient aiServiceClient;

    @Override
    public ResponseEntity<Object> generateMealPlanPreview(Long userId) {
        Optional<NutrisyncUser> user = userRepository.findById(userId);
        if (user.isEmpty()) {
            return new ResponseEntity<>("User Not Found", HttpStatus.NOT_FOUND);
        }

        // ONLY calls AI, does NOT save to DB
        MealPlanResponseDTO generatedPlan = aiServiceClient.generateMealPlanForUser(user.get());
        if (generatedPlan == null) {
            return new ResponseEntity<>("Error Generating Meal Plan Preview", HttpStatus.CONFLICT);
        }

        return new ResponseEntity<>(generatedPlan, HttpStatus.OK);
    }

    @Override
    public ResponseEntity<Object> saveMealPlan(SaveMealPlanRequest request) {
        Optional<NutrisyncUser> user = userRepository.findById(request.getUserId());
        if (user.isEmpty()) {
            return new ResponseEntity<>("User Not Found", HttpStatus.NOT_FOUND);
        }

        MealPlan mealPlan = new MealPlan();
        mealPlan.setUser(user.get());
        mealPlan.setDietPlanName(request.getDietPlanName());
        mealPlan.setDietPlanDescription(request.getDietPlanDescription());
        mealPlan.setDietPlanImage(request.getDietPlanImage());

        // Calculate Start and End Dates (7 day plan)
        Date startDate = new Date();
        mealPlan.setStartDate(startDate);

        Calendar calendar = Calendar.getInstance();
        calendar.setTime(startDate);
        calendar.add(Calendar.DAY_OF_YEAR, 6); // Add 6 days to start date = 7 total days
        mealPlan.setEndDate(calendar.getTime());

        // Loop through the provided DTO and build the graph
        for (MealPlanResponseDTO.DailyPlan dayDto : request.getGeneratedPlan().getWeeklyPlan()) {
            DailyPlan dailyPlan = new DailyPlan();
            dailyPlan.setDayOfWeek(dayDto.getDay());

            for (MealPlanResponseDTO.Meal mealDto : dayDto.getMeals()) {
                PlannedMeal meal = new PlannedMeal();
                try {
                    meal.setMealType(MealTime.valueOf(mealDto.getMealType().trim().toUpperCase()));
                } catch (IllegalArgumentException e) {
                    meal.setMealType(MealTime.SNACK); // Fallback for safety
                }
                meal.setRecipeName(mealDto.getRecipeName());
                meal.setPrepTimeMin(mealDto.getPrepTimeMin());
                meal.setCalories(mealDto.getCalories());
                meal.setProteinG(mealDto.getProteinG());
                meal.setCarbsG(mealDto.getCarbsG());
                meal.setFatG(mealDto.getFatG());
                meal.setImageSearchTerm(mealDto.getImageSearchTerm());

                dailyPlan.addPlannedMeal(meal);
            }
            mealPlan.addDailyPlan(dailyPlan);
        }

        mealPlanRepository.save(mealPlan);
        return new ResponseEntity<>("Meal Plan Saved Successfully", HttpStatus.OK);
    }

    @Override
    public ResponseEntity<Object> getAllDietPlansByUser(Long userId) {
        // Fetches only active plans
        List<MealPlan> activePlans = mealPlanRepository.findAllByUser_UserIdAndIsActiveTrue(userId);

        List<MealPlanSummaryDTO> summaries = new ArrayList<>();
        for (MealPlan plan : activePlans) {
            summaries.add(new MealPlanSummaryDTO(
                    plan.getPlanId(),
                    plan.getDietPlanName(),
                    plan.getDietPlanDescription(),
                    plan.getDietPlanImage(),
                    plan.getStartDate(),
                    plan.getEndDate(),
                    plan.getIsActive()
            ));
        }

        if (summaries.isEmpty()) {
            return new ResponseEntity<>("No Active Diet Plans Found", HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(summaries, HttpStatus.OK);
    }

    @Override
    public ResponseEntity<Object> deleteDietPlan(Long planId) {
        Optional<MealPlan> optionalPlan = mealPlanRepository.findByPlanIdAndIsActiveTrue(planId);
        if (optionalPlan.isEmpty()) {
            return new ResponseEntity<>("Diet Plan Not Found", HttpStatus.NOT_FOUND);
        }
        MealPlan plan = optionalPlan.get();
        plan.setIsActive(false); // Soft Delete
        mealPlanRepository.save(plan);
        return new ResponseEntity<>("Diet Plan Deleted Successfully", HttpStatus.OK);
    }

    @Override
    public ResponseEntity<Object> updateDietPlanDetails(Long planId, UpdateMealPlanDetailsRequest request) {
        Optional<MealPlan> optionalPlan = mealPlanRepository.findByPlanIdAndIsActiveTrue(planId);
        if (optionalPlan.isEmpty()) {
            return new ResponseEntity<>("Diet Plan Not Found", HttpStatus.NOT_FOUND);
        }
        MealPlan plan = optionalPlan.get();
        plan.setDietPlanName(request.getDietPlanName());
        plan.setDietPlanDescription(request.getDietPlanDescription());
        plan.setDietPlanImage(request.getDietPlanImage());

        mealPlanRepository.save(plan);
        return new ResponseEntity<>("Diet Plan Details Updated", HttpStatus.OK);
    }

    @Override
    public ResponseEntity<Object> getDietPlanDetails(Long planId) {
        Optional<MealPlan> optionalPlan = mealPlanRepository.findByPlanIdAndIsActiveTrue(planId);
        if (optionalPlan.isEmpty()) {
            return new ResponseEntity<>("Diet Plan Not Found", HttpStatus.NOT_FOUND);
        }

        MealPlan plan = optionalPlan.get();

        // 1. Map the top-level Plan Details
        DietPlanDetailedDTO dto = new DietPlanDetailedDTO();
        dto.setPlanId(plan.getPlanId());
        dto.setDietPlanName(plan.getDietPlanName());
        dto.setDietPlanDescription(plan.getDietPlanDescription());
        dto.setDietPlanImage(plan.getDietPlanImage());
        dto.setStartDate(plan.getStartDate());
        dto.setEndDate(plan.getEndDate());

        // 2. Loop through the Days
        for (DailyPlan dailyPlan : plan.getDailyPlans()) {
            DailyPlanDTO dayDto = new DailyPlanDTO();
            dayDto.setDay(dailyPlan.getDayOfWeek());

            // 3. Loop through the Meals for that Day
            for (PlannedMeal meal : dailyPlan.getPlannedMeals()) {
                PlannedMealDTO mealDto = new PlannedMealDTO();
                mealDto.setMealId(meal.getPlannedMealId());
                mealDto.setMealType(meal.getMealType().name()); // Converts Enum to String
                mealDto.setRecipeName(meal.getRecipeName());
                mealDto.setImageSearchTerm(meal.getImageSearchTerm());
                mealDto.setPrepTimeMin(meal.getPrepTimeMin());
                mealDto.setCalories(meal.getCalories());
                mealDto.setProteinG(meal.getProteinG());
                mealDto.setCarbsG(meal.getCarbsG());
                mealDto.setFatG(meal.getFatG());

                dayDto.getMeals().add(mealDto);
            }
            dto.getWeeklyPlan().add(dayDto);
        }

        return new ResponseEntity<>(dto, HttpStatus.OK);
    }
}
