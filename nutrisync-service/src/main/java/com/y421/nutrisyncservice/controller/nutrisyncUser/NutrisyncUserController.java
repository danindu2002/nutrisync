package com.y421.nutrisyncservice.controller.nutrisyncUser;

import com.y421.nutrisyncservice.request.nutrisyncUser.*;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequestMapping("/api/v1/user")
public interface NutrisyncUserController {

    //Onboarding API
    @PostMapping("/register")
    ResponseEntity<Object> register(@RequestBody NutrisyncUserRequestDto nutrisyncUserRequestDto);

    @PostMapping("/login")
    ResponseEntity<Object> login(@RequestBody LoginDto loginDto);

    @PostMapping("/logout")
    ResponseEntity<Object> logout();

    @PostMapping("/forgotPassword")
    ResponseEntity<Object> forgotPassword(@RequestParam String email);

    @PostMapping("/validateForgotPwdOtp")
    ResponseEntity<Object> validateForgotPwdOtp(@RequestBody ResetPwdValidationDto dto);

    @PostMapping("/resetForgotPwd")
    ResponseEntity<Object> resetForgotPwd(@RequestBody ResetPwdDto dto);
  
    @GetMapping("/getProfile/{userId}")
    ResponseEntity<Object> getProfile(@PathVariable Long userId);

    @PostMapping("/subscribePremium")
    ResponseEntity<Object> subscribePremium(@RequestBody SubscribePremiumDTO dto);
}
