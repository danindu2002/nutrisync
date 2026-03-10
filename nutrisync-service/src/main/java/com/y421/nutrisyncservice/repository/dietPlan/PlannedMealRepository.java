package com.y421.nutrisyncservice.repository.dietPlan;

import com.y421.nutrisyncservice.entity.dietPlan.PlannedMeal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PlannedMealRepository extends JpaRepository<PlannedMeal, Long> {
}
