package com.y421.nutrisyncservice.repository.dietPlan;

import com.y421.nutrisyncservice.entity.dietPlan.MealPlan;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface MealPlanRepository extends JpaRepository<MealPlan, Long> {
    List<MealPlan> findAllByUser_UserIdAndIsActiveTrue(Long userId);
    Optional<MealPlan> findByPlanIdAndIsActiveTrue(Long planId);
    Optional<MealPlan> findTopByUser_UserIdAndIsActiveTrueOrderByStartDateDesc(Long userId);
}
