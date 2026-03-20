package com.y421.nutrisyncservice.repository.mealLog;

import com.y421.nutrisyncservice.entity.mealLog.MealLog;
import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.util.List;

public interface MealLogRepository extends JpaRepository<MealLog,Long> {

    @Query("SELECT m FROM MealLog m WHERE m.user.userId = :userId AND CAST(m.createdOn AS date) = :date AND m.isDeleted = false")
    List<MealLog> findByUserIdAndDate(@Param("userId") Long userId, @Param("date") LocalDate date);

    List<MealLog> findByUserAndIsDeletedFalse(NutrisyncUser user);
}
