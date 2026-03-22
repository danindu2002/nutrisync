package com.y421.nutrisyncservice.controller.nutrisyncUser;
 
import com.y421.nutrisyncservice.request.nutrisyncUser.*;
import com.y421.nutrisyncservice.service.nutrisyncUser.NutrisyncUserService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
 
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.when;
 
@ExtendWith(MockitoExtension.class)
class NutrisyncUserControllerImplTest {
 
    @Mock
    private NutrisyncUserService userService;
 
    @InjectMocks
    private NutrisyncUserControllerImpl userController;
 
    @Test
    void register_Success() {
        NutrisyncUserRequestDto request = new NutrisyncUserRequestDto();
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("User Registered", HttpStatus.CREATED);
        when(userService.register(any(NutrisyncUserRequestDto.class))).thenReturn(serviceResponse);
 
        ResponseEntity<Object> response = userController.register(request);
 
        assertEquals(HttpStatus.CREATED, response.getStatusCode());
    }
 
    @Test
    void login_Success() {
        LoginDto loginDto = new LoginDto();
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("LoginToken", HttpStatus.OK);
        when(userService.login(any(LoginDto.class))).thenReturn(serviceResponse);
 
        ResponseEntity<Object> response = userController.login(loginDto);
 
        assertEquals(HttpStatus.OK, response.getStatusCode());
    }
 
    @Test
    void getProfile_EdgeCase_UserNotFound() {
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("User not found", HttpStatus.NOT_FOUND);
        when(userService.getProfile(999L)).thenReturn(serviceResponse);
 
        ResponseEntity<Object> response = userController.getProfile(999L);
 
        assertEquals(HttpStatus.NOT_FOUND, response.getStatusCode());
    }
 
    @Test
    void subscribePremium_Success() {
        SubscribePremiumDTO dto = new SubscribePremiumDTO();
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("Subscribed Successfully", HttpStatus.OK);
        when(userService.subscribePremium(any(SubscribePremiumDTO.class))).thenReturn(serviceResponse);
 
        ResponseEntity<Object> response = userController.subscribePremium(dto);
 
        assertEquals(HttpStatus.OK, response.getStatusCode());
    }
 
    @Test
    void updateProfile_Success() throws Exception {
        UpdateProfileRequestDto dto = new UpdateProfileRequestDto();
        ResponseEntity<Object> serviceResponse = new ResponseEntity<>("Profile Updated", HttpStatus.OK);
        // Assuming updateProfile signature is (Long, UpdateProfileRequestDto) since you use @ModelAttribute
        when(userService.updateProfile(anyLong(), any(UpdateProfileRequestDto.class))).thenReturn(serviceResponse);
 
        ResponseEntity<Object> response = userController.updateProfile(1L, dto);
 
        assertEquals(HttpStatus.OK, response.getStatusCode());
    }

    @Test
    void login_InvalidCredentials() {
    // Arrange
    LoginDto loginDto = new LoginDto();
    ResponseEntity<Object> serviceResponse =
            new ResponseEntity<>("Credentials Incorrect", HttpStatus.BAD_REQUEST);

    when(userService.login(any(LoginDto.class)))
            .thenReturn(serviceResponse);

    // Act
    ResponseEntity<Object> response =
            userController.login(loginDto);

    // Assert
    assertEquals(HttpStatus.BAD_REQUEST, response.getStatusCode());
    }

    @Test
    void register_UserAlreadyExists() {
    // Arrange
    NutrisyncUserRequestDto request = new NutrisyncUserRequestDto();

    ResponseEntity<Object> serviceResponse =
            new ResponseEntity<>("User already exist with given E-mail", HttpStatus.CONFLICT);

    when(userService.register(any(NutrisyncUserRequestDto.class)))
            .thenReturn(serviceResponse);

    // Act
    ResponseEntity<Object> response =
            userController.register(request);

    // Assert
    assertEquals(HttpStatus.CONFLICT, response.getStatusCode());
    }

    @Test
    void getUserDetails_Success() {
    // Arrange
    ResponseEntity<Object> serviceResponse =
            new ResponseEntity<>("UserDetails", HttpStatus.OK);

    when(userService.getUserDetails(1L))
            .thenReturn(serviceResponse);

    // Act
    ResponseEntity<Object> response =
            userController.getUserDetails(1L);

    // Assert
    assertEquals(HttpStatus.OK, response.getStatusCode());
    }

}