package com.y421.nutrisyncservice.service.nutrisyncUser;

import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.mapper.NutrisyncUser.NutrisyncUserMapper;
import com.y421.nutrisyncservice.repository.nutrisyncUser.NutrisyncUserRepository;
import com.y421.nutrisyncservice.request.nutrisyncUser.LoginDto;
import com.y421.nutrisyncservice.request.nutrisyncUser.NutrisyncUserRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class NutrisyncUserServiceImpl implements NutrisyncUserService {

    private final NutrisyncUserRepository nutrisyncUserRepository;
    private final NutrisyncUserMapper nutrisyncUserMapper;

    @Override
    public ResponseEntity<Object> register(NutrisyncUserRequestDto dto) {
        try {
            if (nutrisyncUserRepository.existsByEmailAndIsDeletedFalse(dto.getEmail())) {
                return new ResponseEntity<>("User already exist with given E-mail", HttpStatus.CONFLICT);
            }
            nutrisyncUserRepository.save(nutrisyncUserMapper.toEntity(dto));

            return new ResponseEntity<>("User registered successfully", HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Error occurred during registration", HttpStatus.BAD_REQUEST);
        }
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
    public ResponseEntity<Object> getProfile(Long userId) {
        try {
            if (!nutrisyncUserRepository.existsByUserIdAndIsDeletedFalse(userId)) {
                return new ResponseEntity<>("User not found", HttpStatus.NOT_FOUND);
            }
            NutrisyncUser user  = nutrisyncUserRepository.getReferenceById(userId);

            return new ResponseEntity<>(user, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Error occurred during get profile", HttpStatus.BAD_REQUEST);
        }
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
