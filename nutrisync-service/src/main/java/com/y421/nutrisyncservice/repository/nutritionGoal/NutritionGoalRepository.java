package com.y421.nutrisyncservice.repository.nutritionGoal;

import com.y421.nutrisyncservice.entity.nutritionGoal.NutritionGoal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface NutritionGoalRepository extends JpaRepository<NutritionGoal, Long> {
}
