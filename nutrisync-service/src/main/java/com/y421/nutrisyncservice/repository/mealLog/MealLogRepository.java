package com.y421.nutrisyncservice.repository.mealLog;

import com.y421.nutrisyncservice.entity.mealLog.MealLog;
import org.springframework.data.jpa.repository.JpaRepository;

public interface MealLogRepository extends JpaRepository<MealLog,Long> {
}
