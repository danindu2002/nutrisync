package com.y421.nutrisyncservice.util;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "rest")
@Data
public class YamlConfig {
    private String userId;
    private String jwtToken;
    private AuthService nutrisyncService;
    private Service service;

    @Data
    public static class AuthService {
        private String realm;
        private String adminId;
        private String adminSecret;
        private String clientId;
        private String jwkSetUri;
    }

    @Data
    public static class Service {
        private String url;
        private String username;
        private String password;
        private String jwkPath;
        private String tokenPath;
    }
}
