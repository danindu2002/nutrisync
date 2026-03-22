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

    @Query("SELECT m FROM MealLog m " +
            "WHERE m.user.userId = :userId " +
            "AND CAST(m.createdOn AS date) BETWEEN :startDate AND :endDate " +
            "AND m.isDeleted = false " +
            "ORDER BY m.createdOn ASC")
    List<MealLog> findByUserIdAndDateRange(@Param("userId") Long userId,
                                           @Param("startDate") LocalDate startDate,
                                           @Param("endDate") LocalDate endDate);
    @Query("SELECT m FROM MealLog m " +
            "WHERE m.user.userId = :userId " +
            "AND m.isDeleted = false " +
            "ORDER BY m.createdOn ASC")
    List<MealLog> findAllByUserId(@Param("userId") Long userId);
    
    List<MealLog> findByUserAndIsDeletedFalse(NutrisyncUser user);
}
