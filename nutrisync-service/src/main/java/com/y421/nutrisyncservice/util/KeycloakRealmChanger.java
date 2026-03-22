package com.y421.nutrisyncservice.util;

import org.keycloak.admin.client.Keycloak;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Configuration;

@Configuration
public class KeycloakRealmChanger {

    @Qualifier("nutrisyncServiceKeycloak")
    private final Keycloak nutrisyncServiceKeycloak;

    public KeycloakRealmChanger(@Qualifier("nutrisyncServiceKeycloak") Keycloak nutrisyncServiceKeycloak) {
        this.nutrisyncServiceKeycloak = nutrisyncServiceKeycloak;
    }

    public Keycloak changeRealm() {
        return nutrisyncServiceKeycloak;
    }
}
