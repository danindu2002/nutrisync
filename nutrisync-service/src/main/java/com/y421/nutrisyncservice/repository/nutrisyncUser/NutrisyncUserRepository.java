package com.y421.nutrisyncservice.repository.nutrisyncUser;

import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface NutrisyncUserRepository extends JpaRepository<NutrisyncUser, Long> {

    Boolean existsByEmailAndIsDeletedFalse(String email);
    Boolean existsByUserNameAndIsDeletedFalse(String userName);
    Boolean existsByUserIdAndIsDeletedFalse(Long userId);
    Optional<NutrisyncUser> findByEmailAndIsDeletedFalse(String email);
    Optional<NutrisyncUser> findByForgotPwdOtpAndIsDeletedFalse(String email);
    Optional<NutrisyncUser> findByKeycloakUserIdAndIsDeletedFalse(String keycloakUserId);
}
