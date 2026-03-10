package com.y421.nutrisyncservice.service.dietPlan;

import com.y421.nutrisyncservice.entity.dietPlan.DailyPlan;
import com.y421.nutrisyncservice.entity.dietPlan.MealPlan;
import com.y421.nutrisyncservice.entity.dietPlan.PlannedMeal;
import com.y421.nutrisyncservice.entity.mealLog.MealTime;
import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.repository.dietPlan.MealPlanRepository;
import com.y421.nutrisyncservice.repository.nutrisyncUser.NutrisyncUserRepository;
import com.y421.nutrisyncservice.response.dietPlan.MealPlanResponseDTO;
import com.y421.nutrisyncservice.service.ai.AIServiceClient;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class DietPlanServiceImpl implements DietPlanService {

    private final NutrisyncUserRepository userRepository;
    private final MealPlanRepository mealPlanRepository;
    private final AIServiceClient aiServiceClient;

    @Override
    public ResponseEntity<Object> createCustomMealPlan(Long userId) {
        Optional<NutrisyncUser> user = userRepository.findById(userId);
        if (user.isEmpty()) {
           return new ResponseEntity<>("User not found", HttpStatus.NOT_FOUND);
        }
        // 2. Call the AI service
        MealPlanResponseDTO generatedPlan = aiServiceClient.generateMealPlanForUser(user.get());
        if (generatedPlan == null) {
            return new ResponseEntity<>("Error Creating Meal Plan", HttpStatus.CONFLICT);
        }

        // Save plan to DB
        MealPlan mealPlan = new MealPlan();
        mealPlan.setUser(user.get());
        mealPlan.setStartDate(new Date()); // Starts today
        // You could calculate endDate by adding 7 days to startDate

        // 3. Loop through Days and Meals to build the graph
        for (MealPlanResponseDTO.DailyPlan dayDto : generatedPlan.getWeeklyPlan()) {
            DailyPlan dailyPlan = new DailyPlan();
            dailyPlan.setDayOfWeek(dayDto.getDay());

            for (MealPlanResponseDTO.Meal mealDto : dayDto.getMeals()) {
                PlannedMeal meal = new PlannedMeal();
                meal.setMealType(MealTime.valueOf(mealDto.getMealType().toUpperCase()));
                meal.setRecipeName(mealDto.getRecipeName());
                meal.setPrepTimeMin(mealDto.getPrepTimeMin());
                meal.setCalories(mealDto.getCalories());
                meal.setProteinG(mealDto.getProteinG());
                meal.setCarbsG(mealDto.getCarbsG());
                meal.setFatG(mealDto.getFatG());
                meal.setImageSearchTerm(mealDto.getImageSearchTerm());

                dailyPlan.addPlannedMeal(meal); // Links Meal -> Day
            }
            mealPlan.addDailyPlan(dailyPlan); // Links Day -> Master Plan
        }

        // 4. Save everything to the database at once!
        mealPlanRepository.save(mealPlan);

        return new ResponseEntity<>(generatedPlan, HttpStatus.OK);
    }

}
