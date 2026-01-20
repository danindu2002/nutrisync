package com.y421.nutrisyncservice.controller.nutrisyncUser;

import com.y421.nutrisyncservice.request.nutrisyncUser.NutrisyncUserRequestDto;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RequestMapping("/api/v1/user")
public interface NutrisyncUserController {

    @PostMapping("/register")
    ResponseEntity<Object> register(@RequestBody NutrisyncUserRequestDto nutrisyncUserRequestDto);

    @GetMapping("/getProfile/{userId}")
    ResponseEntity<Object> getProfile(@PathVariable Long userId);
}
