package com.y421.nutrisyncservice.service.nutrisyncUser;

import com.y421.nutrisyncservice.request.nutrisyncUser.*;
import org.springframework.http.ResponseEntity;

public interface NutrisyncUserService {

    ResponseEntity<Object> register(NutrisyncUserRequestDto dto);
    ResponseEntity<Object> login(LoginDto dto);
    ResponseEntity<Object> logout();
    ResponseEntity<Object> forgotPassword(String email);
    ResponseEntity<Object> validateForgotPwdOtp(ResetPwdValidationDto dto);
    ResponseEntity<Object> resetForgotPwd(ResetPwdDto dto);
    ResponseEntity<Object> updateProfile(Long userId);
    ResponseEntity<Object> getProfile(Long userId);
    ResponseEntity<Object> deleteAccount();
    ResponseEntity<Object> calculateBMI();
    ResponseEntity<Object> updateMetrics();
    ResponseEntity<Object> getHealthStatus();
    ResponseEntity<Object> subscribePremium(SubscribePremiumDTO dto);
    ResponseEntity<Object> getUserDetails(Long userId);
}
