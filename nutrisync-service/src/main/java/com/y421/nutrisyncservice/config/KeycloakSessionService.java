package com.y421.nutrisyncservice.config;

import com.y421.nutrisyncservice.util.KeycloakRealmChanger;
import com.y421.nutrisyncservice.util.YamlConfig;
import lombok.RequiredArgsConstructor;
import org.keycloak.admin.client.Keycloak;
import org.keycloak.admin.client.resource.RealmResource;
import org.keycloak.representations.idm.UserSessionRepresentation;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class KeycloakSessionService {

    Keycloak currentKeycloak;
    private final YamlConfig yamlConfig;
    private final KeycloakRealmChanger keycloakRealmChanger;

    public boolean isSessionActive(String userId, String sessionId) {
        currentKeycloak = keycloakRealmChanger.changeRealm();
        if (currentKeycloak != null) {
            RealmResource realmResource = currentKeycloak.realm(yamlConfig.getNutrisyncService().getRealm());
            List<UserSessionRepresentation> sessions = realmResource.users().get(userId).getUserSessions();

            Optional<UserSessionRepresentation> activeSession = sessions.stream()
                    .filter(session -> session.getId().equals(sessionId))
                    .findFirst();

            return activeSession.isPresent();
        }
        return false;
    }

    public void logoutUser(String userId) {
        currentKeycloak = keycloakRealmChanger.changeRealm();
        if (currentKeycloak == null) {
            return;
        }
        RealmResource realmResource = currentKeycloak.realm(yamlConfig.getNutrisyncService().getRealm());
        realmResource.users().get(userId).logout();
    }
}
