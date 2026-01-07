package com.y421.nutrisyncservice.service.nutrisyncUser;

import com.y421.nutrisyncservice.request.nutrisyncUser.LoginDto;
import com.y421.nutrisyncservice.request.nutrisyncUser.NutrisyncUserRequestDto;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

@Service
public class NutrisyncUserServiceImpl implements NutrisyncUserService {

    @Override
    public ResponseEntity<Object> register(NutrisyncUserRequestDto dto) {
        return null;
    }

    @Override
    public ResponseEntity<Object> login(LoginDto dto) {
        return null;
    }

    @Override
    public ResponseEntity<Object> updateProfile() {
        return null;
    }

    @Override
    public ResponseEntity<Object> deleteAccount() {
        return null;
    }

    @Override
    public ResponseEntity<Object> calculateBMI() {
        return null;
    }

    @Override
    public ResponseEntity<Object> updateMetrics() {
        return null;
    }

    @Override
    public ResponseEntity<Object> getHealthStatus() {
        return null;
    }
}
