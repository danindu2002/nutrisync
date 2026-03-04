package com.y421.nutrisyncservice.repository.foodMaster;

import com.y421.nutrisyncservice.entity.foodMaster.FoodMaster;
import com.y421.nutrisyncservice.entity.mealLog.MealLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface FoodMasterRepository extends JpaRepository<FoodMaster, Long> {
    Optional<FoodMaster> findByNameIgnoreCase(String name);

    @Query("SELECT f FROM FoodMaster f WHERE LOWER(f.name) LIKE LOWER(CONCAT('%', :label, '%'))")
    List<FoodMaster> searchByLabel(@Param("label") String label);

    @Query("SELECT m FROM MealLog m WHERE m.user.userId = :userId AND CAST(m.createdOn AS date) = :date")
    List<MealLog> findByUserIdAndDate(@Param("userId") Long userId, @Param("date") LocalDate date);
}
