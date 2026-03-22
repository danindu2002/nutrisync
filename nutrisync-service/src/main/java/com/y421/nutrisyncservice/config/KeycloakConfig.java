package com.y421.nutrisyncservice.config;

import com.y421.nutrisyncservice.util.YamlConfig;
import lombok.RequiredArgsConstructor;
import org.keycloak.OAuth2Constants;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.KeycloakBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@RequiredArgsConstructor
public class KeycloakConfig {

    private final YamlConfig yamlConfig;

    @Bean(name = "nutrisyncServiceKeycloak")
    public Keycloak nutrisyncServiceKeycloak() {
        return KeycloakBuilder.builder()
                .serverUrl(yamlConfig.getService().getUrl())
                .realm(yamlConfig.getNutrisyncService().getRealm())
                .username(yamlConfig.getService().getUsername())
                .password(yamlConfig.getService().getPassword())
                .clientId(yamlConfig.getNutrisyncService().getAdminId())
                .clientSecret(yamlConfig.getNutrisyncService().getAdminSecret())
                .grantType(OAuth2Constants.CLIENT_CREDENTIALS)
                .build();
    }
}
