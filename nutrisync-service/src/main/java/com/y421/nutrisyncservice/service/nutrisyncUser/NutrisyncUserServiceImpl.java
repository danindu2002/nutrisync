package com.y421.nutrisyncservice.service.nutrisyncUser;

import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.mapper.nutrisyncUser.NutrisyncUserMapper;
import com.y421.nutrisyncservice.repository.nutrisyncUser.NutrisyncUserRepository;
import com.y421.nutrisyncservice.request.nutrisyncUser.*;
import com.y421.nutrisyncservice.response.email.EmailDetailsDTO;
import com.y421.nutrisyncservice.response.nutrisyncUser.LoginResDto;
import com.y421.nutrisyncservice.util.EmailService;
import com.y421.nutrisyncservice.util.EmailTemplate;
import com.y421.nutrisyncservice.util.KeycloakRealmChanger;
import com.y421.nutrisyncservice.util.YamlConfig;
import jakarta.ws.rs.core.Response;
import lombok.RequiredArgsConstructor;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.KeycloakBuilder;
import org.keycloak.admin.client.resource.UserResource;
import org.keycloak.representations.AccessTokenResponse;
import org.keycloak.representations.idm.CredentialRepresentation;
import org.keycloak.representations.idm.UserRepresentation;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.Collections;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class NutrisyncUserServiceImpl implements NutrisyncUserService {

    private Keycloak currentKeycloak;
    private final KeycloakRealmChanger keycloakRealmChanger;
    private final YamlConfig yamlConfig;
    private final NutrisyncUserRepository userRepository;
    private final NutrisyncUserMapper nutrisyncUserMapper;
    private final EmailTemplate emailTemplate;
    private final EmailService emailService;

    @Value("${rest.nutrisync-service.realm}")
    private String serviceName;

    @Value("${new-login-pwd.length}")
    private Integer newLoginPwdLength;

    @Value("${new-login-pwd.letters}")
    private Boolean newLoginPwdLetters;

    @Value("${new-login-pwd.numbers}")
    private Boolean newLoginPwdNumbers;

    @Override
    public ResponseEntity<Object> register(NutrisyncUserRequestDto dto) {
        try {
            if (!userRepository.existsByUserNameAndIsDeletedFalse(dto.getUserName())) {
                return new ResponseEntity<>("User Name is taken. Please try another User Name.", HttpStatus.CONFLICT);
            }
            if (userRepository.existsByEmailAndIsDeletedFalse(dto.getEmail())) {
                return new ResponseEntity<>("User already exist with given E-mail", HttpStatus.CONFLICT);
            }

            currentKeycloak = keycloakRealmChanger.changeRealm();
            UserRepresentation userKeycloak = getUserRepresentation(dto);
            Response response = currentKeycloak.realm(serviceName).users().create(userKeycloak);
            if (response.getStatusInfo().getStatusCode() == 409) {
                return new ResponseEntity<>("User already Exists", HttpStatus.BAD_REQUEST);
            } else if (response.getStatusInfo().getStatusCode() == 201) {
                String userId = response.getLocation().getPath().replaceAll(".*/([^/]+)$", "$1");
                clearUserRequiredActions(userId, serviceName);

                NutrisyncUser user = nutrisyncUserMapper.toEntity(dto);
                user.setKeycloakUserId(userId);
                userRepository.save(user);

                return new ResponseEntity<>("User Creation Success", HttpStatus.OK);
            }
            System.out.println(response.getStatusInfo().getStatusCode());
            return new ResponseEntity<>("User Creation Failed", HttpStatus.BAD_REQUEST);

//            return new ResponseEntity<>("User registered successfully", HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Error occurred during onboarding", HttpStatus.BAD_REQUEST);
        }
    }

    @Override
    public ResponseEntity<Object> login(LoginDto dto) {
        try (
                Keycloak keycloak = KeycloakBuilder.builder()
                        .serverUrl(yamlConfig.getService().getUrl())
                        .realm(serviceName)
                        .username(dto.getUserName())
                        .password(dto.getPassword())
                        .clientId(yamlConfig.getNutrisyncService().getClientId())
                        .build()
        ) {
            AccessTokenResponse accessToken = keycloak.tokenManager().getAccessToken();
            Optional<NutrisyncUser> user = userRepository.findByKeycloakUserIdAndIsDeletedFalse(accessToken.getToken());
            if (user.isEmpty()) {
                return new ResponseEntity<>("User Not Found", HttpStatus.NOT_FOUND);
            }
            LoginResDto loginResDto = new LoginResDto(accessToken, user.get().getUserId());
            return new ResponseEntity<>(loginResDto, HttpStatus.OK);
        } catch (Exception e) {
            String message = e.getMessage();
            if (e.getMessage().contains("401")) {
                message = "Credentials Incorrect";
            }
            return new ResponseEntity<>(message, HttpStatus.BAD_REQUEST);
        }
    }

    @Override
    public ResponseEntity<Object> logout() {
        try {
            currentKeycloak = keycloakRealmChanger.changeRealm();
            if (currentKeycloak == null) {
                return serviceValidation();
            }
            currentKeycloak.realm(serviceName).users().get(yamlConfig.getUserId()).logout();
            return new ResponseEntity<>("Logout Successfully", HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        } finally {
            currentKeycloak = null;
        }
    }

    @Override
    public ResponseEntity<Object> forgotPassword(String email) {
        try {
            Optional<NutrisyncUser> user = userRepository.findByEmailAndIsDeletedFalse(email);
            if (user.isEmpty()) {
                return new ResponseEntity<>("Email Not Found", HttpStatus.BAD_REQUEST);
            }
            NutrisyncUser appUser = user.get();

            String token = createOtp();
            yamlConfig.setUserId(appUser.getKeycloakUserId());
            appUser.setForgotPwdOtp(token);
            userRepository.save(appUser);
            forgetPasswordEmail(user.get());
            return new ResponseEntity<>("Email Sent", HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @Override
    public ResponseEntity<Object> validateForgotPwdOtp(ResetPwdValidationDto dto) {
        try {
            Optional<NutrisyncUser> user = userRepository.findByEmailAndIsDeletedFalse(dto.getEmail());
            if (user.isEmpty()) {
                return new ResponseEntity<>("User For Email Not Found", HttpStatus.BAD_REQUEST);
            }
            NutrisyncUser appUser = user.get();
            if(dto.getOtp() != null && dto.getOtp().equals(appUser.getForgotPwdOtp())) {
                appUser.setForgotPwdOtp(null);
                userRepository.save(appUser);
                return new ResponseEntity<>("OTP Correct", HttpStatus.OK);
            } else {
                return new ResponseEntity<>("OTP Wrong", HttpStatus.NOT_FOUND);
            }
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @Override
    public ResponseEntity<Object> resetForgotPwd(ResetPwdDto dto) {
        try {
            currentKeycloak = keycloakRealmChanger.changeRealm();
            if (currentKeycloak == null) {
                return serviceValidation();
            }
            Optional<NutrisyncUser> user = userRepository.findByForgotPwdOtpAndIsDeletedFalse(dto.getOtp());
            if (user.isEmpty()) {
                return new ResponseEntity<>("Token Invalid", HttpStatus.BAD_REQUEST);
            }

            NutrisyncUser appUsers = user.get();
            yamlConfig.setUserId(appUsers.getKeycloakUserId());
            appUsers.setForgotPwdOtp(null);
            appUsers.setPassword(dto.getNewPassword());
            userRepository.save(appUsers);

            currentKeycloak.realm(serviceName).users().get(user.get().getKeycloakUserId()).resetPassword(createPasswordCredentials(dto.getNewPassword()));
            return new ResponseEntity<>("Password Changed Successfully", HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(e.getMessage(), HttpStatus.BAD_REQUEST);
        } finally {
            currentKeycloak = null;
        }
    }

    @Override
    public ResponseEntity<Object> updateProfile(Long userId) {
        try {
            if (!userRepository.existsByUserIdAndIsDeletedFalse(userId)) {
                return new ResponseEntity<>("User not found", HttpStatus.NOT_FOUND);
            }
            NutrisyncUser user  = userRepository.getReferenceById(userId);

            return new ResponseEntity<>(user, HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            return new ResponseEntity<>("Error occurred during get profile", HttpStatus.BAD_REQUEST);
        }
    }

    @Override
    public ResponseEntity<Object> getProfile(Long userId) {
        try {
            if (!userRepository.existsByUserIdAndIsDeletedFalse(userId)) {
                return new ResponseEntity<>("User not found", HttpStatus.NOT_FOUND);
            }
            NutrisyncUser user  = userRepository.getReferenceById(userId);

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

    private UserRepresentation getUserRepresentation(NutrisyncUserRequestDto userCreateDTO) {
        UserRepresentation userKeycloak = new UserRepresentation();
        userKeycloak.setUsername(userCreateDTO.getEmail());
        userKeycloak.setFirstName(userCreateDTO.getFirstName());
        userKeycloak.setLastName(userCreateDTO.getLastName());
        userKeycloak.setEmail(userCreateDTO.getEmail());
        userKeycloak.setEnabled(true);
        userKeycloak.setEmailVerified(true);

        CredentialRepresentation passwordCredentials = new CredentialRepresentation();
        passwordCredentials.setTemporary(false);
        passwordCredentials.setType(CredentialRepresentation.PASSWORD);
//        String password = RandomStringUtils.random(newLoginPwdLength, newLoginPwdLetters, newLoginPwdNumbers);
        passwordCredentials.setValue(userCreateDTO.getPassword());

        userKeycloak.setCredentials(List.of(passwordCredentials));
        userKeycloak.setRequiredActions(Collections.emptyList());
        return userKeycloak;
    }

    public void clearUserRequiredActions(String userId, String serviceName) {
        UserResource userResource = currentKeycloak.realm(serviceName).users().get(userId);
        UserRepresentation user = userResource.toRepresentation();
        user.setRequiredActions(Collections.emptyList());
        userResource.update(user);
    }

    private String createOtp() {
        int otp = new java.security.SecureRandom().nextInt(1_000_000);
        return String.format("%06d", otp);
    }

    private void forgetPasswordEmail(NutrisyncUser appUser) {
        EmailDetailsDTO emailDetailsDTO = new EmailDetailsDTO();
        emailDetailsDTO.setRecipient(appUser.getEmail());
        emailDetailsDTO.setSubject("Nutrisync Password Reset");
        emailDetailsDTO.setMessageBody(emailTemplate.emailTemplateForgotPassword(appUser.getForgotPwdOtp()));
        emailService.sendEmail(emailDetailsDTO);
    }

    public CredentialRepresentation createPasswordCredentials(String password) {
        CredentialRepresentation passwordCredentials = new CredentialRepresentation();
        passwordCredentials.setTemporary(false);
        passwordCredentials.setType(CredentialRepresentation.PASSWORD);
        passwordCredentials.setValue(password);
        return passwordCredentials;
    }

    private ResponseEntity<Object> serviceValidation() {
        return new ResponseEntity<>("Invalid Service Name", HttpStatus.BAD_REQUEST);

    }
}
