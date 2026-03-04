package com.y421.nutrisyncservice.repository.foodMaster;

import com.y421.nutrisyncservice.entity.foodMaster.FoodMaster;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface FoodMasterRepository extends JpaRepository<FoodMaster, Long> {
    Optional<FoodMaster> findByLabelIgnoreCase(String name);
}
