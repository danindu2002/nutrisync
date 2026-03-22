package com.y421.nutrisyncservice.repository.dietPlan;

import com.y421.nutrisyncservice.entity.dietPlan.DailyPlan;
import org.springframework.data.jpa.repository.JpaRepository;

import javax.annotation.Resource;

@Resource
public interface DailyPlanRepository extends JpaRepository<DailyPlan, Long> {
}
