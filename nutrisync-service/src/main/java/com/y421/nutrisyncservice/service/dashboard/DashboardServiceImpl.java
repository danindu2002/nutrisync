package com.y421.nutrisyncservice.service.dashboard;

import com.y421.nutrisyncservice.entity.mealLog.MealLog;
import com.y421.nutrisyncservice.entity.mealLog.MealTime;
import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.repository.mealLog.MealLogRepository;
import com.y421.nutrisyncservice.repository.nutrisyncUser.NutrisyncUserRepository;
import com.y421.nutrisyncservice.response.dashboard.CaloriesChartDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.ZoneId;
import java.time.format.TextStyle;
import java.time.temporal.TemporalAdjusters;
import java.util.*;

@Service
@RequiredArgsConstructor
public class DashboardServiceImpl implements DashboardService {

    private final MealLogRepository mealLogRepository;
    private final NutrisyncUserRepository userRepository;

    @Override
    public ResponseEntity<Object> getCaloriesChart(Long userId, String range) {
        try {
            Optional<NutrisyncUser> userOptional = userRepository.findById(userId);
            if (userOptional.isEmpty()) {
                return new ResponseEntity<>("User not found", HttpStatus.NOT_FOUND);
            }

            String normalizedRange = range.toLowerCase();
            LocalDate today = LocalDate.now();

            CaloriesChartDTO response;

            switch (normalizedRange) {
                case "day":
                case "1d":
                    response = buildDayChart(userId, today);
                    break;
                case "week":
                case "1w":
                    response = buildWeekChart(userId, today);
                    break;
                case "month":
                case "1m":
                    response = buildMonthChart(userId, today);
                    break;
                case "year":
                case "1y":
                    response = buildYearChart(userId, today);
                    break;
                case "all":
                    response = buildAllChart(userId);
                    break;
                default:
                    return new ResponseEntity<>("Invalid range value", HttpStatus.BAD_REQUEST);
            }

            return new ResponseEntity<>(response, HttpStatus.OK);

        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Error Occurred", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    private CaloriesChartDTO buildDayChart(Long userId, LocalDate today) {
        List<MealLog> logs = mealLogRepository.findByUserIdAndDate(userId, today);

        Map<String, Double> mealTimeMap = new LinkedHashMap<>();
        mealTimeMap.put("Breakfast", 0.0);
        mealTimeMap.put("Lunch", 0.0);
        mealTimeMap.put("Dinner", 0.0);
        mealTimeMap.put("Snack", 0.0);

        double totalCalories = 0.0;

        for (MealLog log : logs) {
            double calories = log.getTotalCalories() != null ? log.getTotalCalories() : 0.0;
            totalCalories += calories;

            if (log.getMealTime() != null) {
                switch (log.getMealTime()) {
                    case BREAKFAST -> mealTimeMap.put("Breakfast", mealTimeMap.get("Breakfast") + calories);
                    case LUNCH -> mealTimeMap.put("Lunch", mealTimeMap.get("Lunch") + calories);
                    case DINNER -> mealTimeMap.put("Dinner", mealTimeMap.get("Dinner") + calories);
                    case SNACK -> mealTimeMap.put("Snack", mealTimeMap.get("Snack") + calories);
                }
            }
        }

        return CaloriesChartDTO.builder()
                .labels(new ArrayList<>(mealTimeMap.keySet()))
                .values(new ArrayList<>(mealTimeMap.values()))
                .totalCalories(totalCalories)
                .range("day")
                .build();
    }

    private CaloriesChartDTO buildWeekChart(Long userId, LocalDate today) {
        LocalDate startOfWeek = today.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
        LocalDate endOfWeek = today.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY));

        List<MealLog> logs = mealLogRepository.findByUserIdAndDateRange(userId, startOfWeek, endOfWeek);

        Map<LocalDate, Double> dailyCaloriesMap = new LinkedHashMap<>();
        for (LocalDate date = startOfWeek; !date.isAfter(endOfWeek); date = date.plusDays(1)) {
            dailyCaloriesMap.put(date, 0.0);
        }

        for (MealLog log : logs) {
            LocalDate logDate = log.getCreatedOn().toInstant()
                    .atZone(ZoneId.systemDefault())
                    .toLocalDate();

            double calories = log.getTotalCalories() != null ? log.getTotalCalories() : 0.0;
            dailyCaloriesMap.put(logDate, dailyCaloriesMap.getOrDefault(logDate, 0.0) + calories);
        }

        List<String> labels = dailyCaloriesMap.keySet().stream()
                .map(date -> date.getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.ENGLISH))
                .toList();

        List<Double> values = new ArrayList<>(dailyCaloriesMap.values());
        double totalCalories = dailyCaloriesMap.values()
                .stream()
                .mapToDouble(Double::doubleValue)
                .sum();



        return CaloriesChartDTO.builder()
                .labels(labels)
                .values(values)
                .totalCalories(totalCalories)
                .range("week")
                .build();
    }

    private CaloriesChartDTO buildMonthChart(Long userId, LocalDate today) {
        LocalDate startOfMonth = today.withDayOfMonth(1);
        LocalDate endOfMonth = today.withDayOfMonth(today.lengthOfMonth());

        List<MealLog> logs = mealLogRepository.findByUserIdAndDateRange(userId, startOfMonth, endOfMonth);

        Map<String, Double> weekMap = new LinkedHashMap<>();
        weekMap.put("Week 1", 0.0);
        weekMap.put("Week 2", 0.0);
        weekMap.put("Week 3", 0.0);
        weekMap.put("Week 4", 0.0);
        weekMap.put("Week 5", 0.0);

        for (MealLog log : logs) {
            LocalDate logDate = log.getCreatedOn().toInstant()
                    .atZone(ZoneId.systemDefault())
                    .toLocalDate();

            int weekNumber = ((logDate.getDayOfMonth() - 1) / 7) + 1;
            String weekLabel = "Week " + weekNumber;

            double calories = log.getTotalCalories() != null ? log.getTotalCalories() : 0.0;
            weekMap.put(weekLabel, weekMap.getOrDefault(weekLabel, 0.0) + calories);
        }

        double totalCalories = logs.stream()
                .mapToDouble(log -> log.getTotalCalories() != null ? log.getTotalCalories() : 0.0)
                .sum();

        return CaloriesChartDTO.builder()
                .labels(new ArrayList<>(weekMap.keySet()))
                .values(new ArrayList<>(weekMap.values()))
                .totalCalories(totalCalories)
                .range("month")
                .build();
    }

    private CaloriesChartDTO buildYearChart(Long userId, LocalDate today) {
        LocalDate startOfYear = today.withDayOfYear(1);
        LocalDate endOfYear = today.withDayOfYear(today.lengthOfYear());

        List<MealLog> logs = mealLogRepository.findByUserIdAndDateRange(userId, startOfYear, endOfYear);

        Map<String, Double> monthMap = new LinkedHashMap<>();
        for (int month = 1; month <= 12; month++) {
            String monthLabel = java.time.Month.of(month).getDisplayName(TextStyle.SHORT, Locale.ENGLISH);
            monthMap.put(monthLabel, 0.0);
        }

        for (MealLog log : logs) {
            LocalDate logDate = log.getCreatedOn().toInstant()
                    .atZone(ZoneId.systemDefault())
                    .toLocalDate();

            String monthLabel = logDate.getMonth().getDisplayName(TextStyle.SHORT, Locale.ENGLISH);
            double calories = log.getTotalCalories() != null ? log.getTotalCalories() : 0.0;
            monthMap.put(monthLabel, monthMap.getOrDefault(monthLabel, 0.0) + calories);
        }

        double totalCalories = logs.stream()
                .mapToDouble(log -> log.getTotalCalories() != null ? log.getTotalCalories() : 0.0)
                .sum();

        return CaloriesChartDTO.builder()
                .labels(new ArrayList<>(monthMap.keySet()))
                .values(new ArrayList<>(monthMap.values()))
                .totalCalories(totalCalories)
                .range("year")
                .build();
    }

    private CaloriesChartDTO buildAllChart(Long userId) {
        Optional<NutrisyncUser> userOptional = userRepository.findById(userId);
        if (userOptional.isEmpty()) {
            return CaloriesChartDTO.builder()
                    .labels(Collections.emptyList())
                    .values(Collections.emptyList())
                    .totalCalories(0.0)
                    .range("all")
                    .build();
        }

        LocalDate startDate = userOptional.get().getRegDate().toInstant()
                .atZone(ZoneId.systemDefault())
                .toLocalDate();
        LocalDate endDate = LocalDate.now();

        List<MealLog> logs = mealLogRepository.findByUserIdAndDateRange(userId, startDate, endDate);

        Map<String, Double> monthYearMap = new LinkedHashMap<>();

        for (MealLog log : logs) {
            LocalDate logDate = log.getCreatedOn().toInstant()
                    .atZone(ZoneId.systemDefault())
                    .toLocalDate();

            String label = logDate.getMonth().getDisplayName(TextStyle.SHORT, Locale.ENGLISH)
                    + " " + logDate.getYear();

            monthYearMap.putIfAbsent(label, 0.0);

            double calories = log.getTotalCalories() != null ? log.getTotalCalories() : 0.0;
            monthYearMap.put(label, monthYearMap.get(label) + calories);
        }

        double totalCalories = logs.stream()
                .mapToDouble(log -> log.getTotalCalories() != null ? log.getTotalCalories() : 0.0)
                .sum();

        return CaloriesChartDTO.builder()
                .labels(new ArrayList<>(monthYearMap.keySet()))
                .values(new ArrayList<>(monthYearMap.values()))
                .totalCalories(totalCalories)
                .range("all")
                .build();
    }
}