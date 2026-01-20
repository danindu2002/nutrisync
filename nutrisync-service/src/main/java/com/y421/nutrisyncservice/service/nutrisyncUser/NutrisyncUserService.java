package com.y421.nutrisyncservice.service.nutrisyncUser;

import com.y421.nutrisyncservice.request.nutrisyncUser.LoginDto;
import com.y421.nutrisyncservice.request.nutrisyncUser.NutrisyncUserRequestDto;
import org.springframework.http.ResponseEntity;

public interface NutrisyncUserService {

    ResponseEntity<Object> register(NutrisyncUserRequestDto dto);
    ResponseEntity<Object> login(LoginDto dto);
    ResponseEntity<Object> updateProfile();
    ResponseEntity<Object> getProfile(Long userId);
    ResponseEntity<Object> deleteAccount();
    ResponseEntity<Object> calculateBMI();
    ResponseEntity<Object> updateMetrics();
    ResponseEntity<Object> getHealthStatus();
}
