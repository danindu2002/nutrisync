package com.y421.nutrisyncservice.controller.nutrisyncUser;

import com.y421.nutrisyncservice.request.nutrisyncUser.NutrisyncUserRequestDto;
import com.y421.nutrisyncservice.service.nutrisyncUser.NutrisyncUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

import static com.y421.nutrisyncservice.util.ResponseHandler.generateResponse;

@RestController
@RequiredArgsConstructor
public class NutrisyncUserControllerImpl implements NutrisyncUserController {

    private final NutrisyncUserService nutrisyncUserService;

    @Override
    public ResponseEntity<Object> register(NutrisyncUserRequestDto nutrisyncUserRequestDto) {
        try {
            ResponseEntity<Object> response = nutrisyncUserService.register(nutrisyncUserRequestDto);
            if (response.getStatusCode().isSameCodeAs(HttpStatus.CREATED)) {
                return generateResponse("User Created Successfully", HttpStatus.OK, response.getBody());
            } else {
                return generateResponse((String) response.getBody(), (HttpStatus) response.getStatusCode(), null);
            }
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }

    @Override
    public ResponseEntity<Object> getProfile(Long userId) {
        try {
            ResponseEntity<Object> response = nutrisyncUserService.getProfile(userId);
            if (response.getStatusCode().isSameCodeAs(HttpStatus.OK)) {
                return generateResponse("User Retrieved Successfully", HttpStatus.OK, response.getBody());
            } else {
                return generateResponse((String) response.getBody(), (HttpStatus) response.getStatusCode(), null);
            }
        } catch (Exception e) {
            return generateResponse("Error Occurred", HttpStatus.BAD_REQUEST, null);
        }
    }
}
