package com.y421.nutrisyncservice.service.nutrisyncUser;

import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.mapper.nutrisyncUser.NutrisyncUserMapper;
import com.y421.nutrisyncservice.repository.nutrisyncUser.NutrisyncUserRepository;
import com.y421.nutrisyncservice.request.nutrisyncUser.LoginDto;
import com.y421.nutrisyncservice.request.nutrisyncUser.NutrisyncUserRequestDto;
import com.y421.nutrisyncservice.util.KeycloakRealmChanger;
import com.y421.nutrisyncservice.util.YamlConfig;
import jakarta.ws.rs.core.Response;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.RandomStringUtils;
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

import java.util.Collections;
import java.util.List;

@Service
@RequiredArgsConstructor
public class NutrisyncUserServiceImpl implements NutrisyncUserService {

    private Keycloak currentKeycloak;
    private final KeycloakRealmChanger keycloakRealmChanger;
    private final YamlConfig yamlConfig;
    private final NutrisyncUserRepository userRepository;
    private final NutrisyncUserMapper nutrisyncUserMapper;

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
            return new ResponseEntity<>("Error occurred during registration", HttpStatus.BAD_REQUEST);
        }
    }

    @Override
    public ResponseEntity<Object> login(LoginDto dto) {
        try (
                Keycloak keycloak = KeycloakBuilder.builder()
                        .serverUrl(yamlConfig.getService().getUrl())
                        .realm(serviceName)
                        .username(dto.getEmail())
                        .password(dto.getPassword())
                        .clientId(yamlConfig.getNutrisyncService().getClientId())
                        .build()
        ) {
            AccessTokenResponse accessToken = keycloak.tokenManager().getAccessToken();
            return new ResponseEntity<>(accessToken, HttpStatus.OK);
        } catch (Exception e) {
            String message = e.getMessage();
            if (e.getMessage().contains("401")) {
                message = "Password Incorrect";
            }
            return new ResponseEntity<>(message, HttpStatus.BAD_REQUEST);
        }
    }

    @Override
    public ResponseEntity<Object> updateProfile() {
        return null;
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
}
