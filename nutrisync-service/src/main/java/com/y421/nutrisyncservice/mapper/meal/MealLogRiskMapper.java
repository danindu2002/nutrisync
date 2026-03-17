package com.y421.nutrisyncservice.mapper.meal;

import com.y421.nutrisyncservice.entity.mealLog.MealLog;
import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.request.meal.MealLogRiskRequestDTO;
import com.y421.nutrisyncservice.request.meal.MealTimesDTO;
import com.y421.nutrisyncservice.request.meal.MealLogDTO;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Component
public class MealLogRiskMapper {

    /**
     * Maps a NutrisyncUser entity and a list of MealLog entities to MealLogRiskRequestDTO
     * Combines all user profile data with meal logs for risk prediction
     *
     * @param user The NutrisyncUser entity
     * @param mealLogs List of MealLog entities for the user
     * @return MealLogRiskRequestDTO with all matching fields populated
     */
    public MealLogRiskRequestDTO toMealLogRiskRequestDTO(NutrisyncUser user, List<MealLog> mealLogs) {
        MealLogRiskRequestDTO dto = new MealLogRiskRequestDTO();

        // Map user profile fields
        if (user != null) {
            dto.setGender(user.getGender());
            dto.setAge(user.getAge() != null ? user.getAge() : 0);
            dto.setHeightCm(user.getHeightCm() != null ? user.getHeightCm().doubleValue() : 0.0);
            dto.setWeightKg(user.getWeightKg() != null ? user.getWeightKg().doubleValue() : 0.0);
            dto.setBmi(user.getBmi() != null ? user.getBmi().doubleValue() : 0.0);
            dto.setActivityLevel(user.getActivityLevel());
            dto.setGoalSpeed(user.getGoalSpeed());
            dto.setDietaryPreferences(user.getDietaryPreferences());
            dto.setAllergies(user.getAllergies());
            dto.setMedicalConditions(user.getMedicalConditions());
            dto.setDailyCalorieGoal(user.getDailyCalorieGoal() != null ? user.getDailyCalorieGoal() : 0);
            dto.setSleepQuality(user.getSleepQuality());

            // Convert meal times from Map to MealTimesDTO
            if (user.getMealTimes() != null) {
                dto.setMealTimes(convertMealTimesMapToDTO(user.getMealTimes()));
            }
        }

        // Map meal logs with food master information
        if (mealLogs != null && !mealLogs.isEmpty()) {
            List<MealLogDTO> mealLogDTOs = mealLogs.stream()
                    .map(this::toMealLogDTO)
                    .collect(Collectors.toList());
            dto.setMealLogList(mealLogDTOs);
        } else {
            dto.setMealLogList(new ArrayList<>());
        }

        return dto;
    }

    /**
     * Maps a single MealLog entity to MealLogDTO, including FoodMaster information
     *
     * @param mealLog The MealLog entity
     * @return MealLogDTO with all meal and food information
     */
    private MealLogDTO toMealLogDTO(MealLog mealLog) {
        if (mealLog == null) {
            return null;
        }

        MealLogDTO dto = new MealLogDTO();

        // Map basic meal log fields
        dto.setLogId(mealLog.getLogId());
        dto.setFoodName(mealLog.getFoodName());
        dto.setTotalProtein(mealLog.getTotalProtein() != null ? mealLog.getTotalProtein().doubleValue() : 0.0);
        dto.setTotalCarbs(mealLog.getTotalCarbs() != null ? mealLog.getTotalCarbs().doubleValue() : 0.0);
        dto.setTotalCalories(mealLog.getTotalCalories() != null ? mealLog.getTotalCalories().doubleValue() : 0.0);
        dto.setConsumedQuantity(mealLog.getConsumedQuantity() != null ? mealLog.getConsumedQuantity().doubleValue() : 0.0);
        dto.setMealTime(mealLog.getMealTime() != null ? mealLog.getMealTime().toString() : null);
        dto.setNotes(mealLog.getNotes());

        // Map FoodMaster information
        if (mealLog.getFoodMaster() != null) {
            dto.setFoodMaster(mealLog.getFoodMaster());
        }

        return dto;
    }

    /**
     * Converts a Map<String, String> of meal times to MealTimesDTO
     * Expected map keys: "breakfast", "lunch", "dinner"
     *
     * @param mealTimesMap Map containing meal time mappings
     * @return MealTimesDTO with breakfast, lunch, and dinner times
     */
    private MealTimesDTO convertMealTimesMapToDTO(Map<String, String> mealTimesMap) {
        MealTimesDTO mealTimesDTO = new MealTimesDTO();

        if (mealTimesMap != null) {
            mealTimesDTO.setBreakfast(mealTimesMap.get("breakfast"));
            mealTimesDTO.setLunch(mealTimesMap.get("lunch"));
            mealTimesDTO.setDinner(mealTimesMap.get("dinner"));
        }

        return mealTimesDTO;
    }

    /**
     * Reverse conversion: Maps MealLogRiskRequestDTO back to NutrisyncUser entity
     * Useful for updating user profile from risk request
     *
     * @param dto MealLogRiskRequestDTO
     * @param user Existing NutrisyncUser entity to update
     * @return Updated NutrisyncUser entity
     */
    public NutrisyncUser toNutrisyncUser(MealLogRiskRequestDTO dto, NutrisyncUser user) {
        if (dto == null) {
            return user;
        }

        user.setGender(dto.getGender());
        user.setAge(dto.getAge());
        user.setHeightCm((float) dto.getHeightCm());
        user.setWeightKg((float) dto.getWeightKg());
        user.setBmi((float) dto.getBmi());
        user.setActivityLevel(dto.getActivityLevel());
        user.setGoalSpeed(dto.getGoalSpeed());
        user.setDietaryPreferences(dto.getDietaryPreferences());
        user.setAllergies(dto.getAllergies());
        user.setMedicalConditions(dto.getMedicalConditions());
        user.setDailyCalorieGoal(dto.getDailyCalorieGoal());
        user.setSleepQuality(dto.getSleepQuality());

        // Convert MealTimesDTO back to Map
        if (dto.getMealTimes() != null) {
            user.setMealTimes(convertMealTimesDTOToMap(dto.getMealTimes()));
        }

        return user;
    }

    /**
     * Converts MealTimesDTO to Map<String, String>
     *
     * @param mealTimesDTO MealTimesDTO object
     * @return Map with breakfast, lunch, dinner entries
     */
    private Map<String, String> convertMealTimesDTOToMap(MealTimesDTO mealTimesDTO) {
        return Map.of(
                "breakfast", mealTimesDTO.getBreakfast() != null ? mealTimesDTO.getBreakfast() : "",
                "lunch", mealTimesDTO.getLunch() != null ? mealTimesDTO.getLunch() : "",
                "dinner", mealTimesDTO.getDinner() != null ? mealTimesDTO.getDinner() : ""
        );
    }
}

