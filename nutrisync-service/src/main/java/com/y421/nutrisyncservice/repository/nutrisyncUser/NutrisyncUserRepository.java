package com.y421.nutrisyncservice.repository.nutrisyncUser;

import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface NutrisyncUserRepository extends JpaRepository<NutrisyncUser, Long> {

    Boolean existsByEmailAndIsDeletedFalse(String email);
}
