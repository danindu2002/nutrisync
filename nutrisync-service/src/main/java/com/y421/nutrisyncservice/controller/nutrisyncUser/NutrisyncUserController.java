package com.y421.nutrisyncservice.controller.nutrisyncUser;

import com.y421.nutrisyncservice.request.nutrisyncUser.NutrisyncUserRequestDto;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/api/v1/user")
public interface NutrisyncUserController {

    @PostMapping("/register")
    ResponseEntity<Object> register(@RequestBody NutrisyncUserRequestDto nutrisyncUserRequestDto);
}
