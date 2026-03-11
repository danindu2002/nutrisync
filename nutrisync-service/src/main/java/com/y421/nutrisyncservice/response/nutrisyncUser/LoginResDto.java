package com.y421.nutrisyncservice.response.nutrisyncUser;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.keycloak.representations.AccessTokenResponse;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class LoginResDto {
    private AccessTokenResponse accessToken;
    private Long userId;
}
