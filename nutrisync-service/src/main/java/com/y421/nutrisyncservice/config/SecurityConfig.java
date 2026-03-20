package com.y421.nutrisyncservice.config;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.y421.nutrisyncservice.util.JwtDecoder;
import jakarta.servlet.http.HttpServletResponse;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authorization.AuthorizationDecision;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.oauth2.server.resource.InvalidBearerTokenException;
import org.springframework.security.oauth2.server.resource.web.authentication.BearerTokenAuthenticationFilter;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import java.io.IOException;
import java.io.PrintWriter;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final JwtAuthConverter jwtAuthConverter;
    private final KeycloakSessionService keycloakSessionService;
    private final JwtDecoder jwtDecoder;

    private static final String[] WHITE_LIST_URL = {
            "/v2/api-docs",
            "/v3/api-docs",
            "/v3/api-docs/**",
            "/api/v1/auth/signInSso",
            "/api/v1/auth/refreshToken",
            "/swagger-resources",
            "/swagger-resources/**",
            "/configuration/ui",
            "/configuration/security",
            "/swagger-ui/**",
            "/webjars/**",
            "/swagger-ui.html",
            "/api/v1/user/**",
    };

    private static final String[] PROTECTED_LIST_URL = {
            "/api/v1/auth/logout",
            "/api/v1/auth/getProfileImage",
            "/api/v1/reference/**",
            "/api/v1/meal/**",
            "/api/v1/diet-plan/**",
            "/api/v1/challenges/**",
            "/api/v1/rewards/**",
            "/api/v1/riskPredictor/**",
    };

    @Bean
    public SecurityFilterChain createSecurityFilterChain(HttpSecurity http) throws Exception {
        KeycloakSessionValidationFilter keycloakSessionValidationFilter =
                new KeycloakSessionValidationFilter(keycloakSessionService, jwtDecoder);

        http
                .csrf(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests(req -> {
                    req.requestMatchers(WHITE_LIST_URL).permitAll();
                    req.requestMatchers(PROTECTED_LIST_URL).authenticated();
                });

        exceptionHandler(http);

        http.addFilterAfter(
                keycloakSessionValidationFilter,
                BearerTokenAuthenticationFilter.class
        );

        http.sessionManagement(session ->
                session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
        );

        http.oauth2ResourceServer(jwt -> jwt
                .accessDeniedHandler((req, res, e) ->
                        handleException(res, e, HttpServletResponse.SC_UNAUTHORIZED))
                .authenticationEntryPoint((req, res, e) ->
                        handleException(res, e, HttpServletResponse.SC_FORBIDDEN))
                .jwt(jwt1 ->
                        jwt1.jwtAuthenticationConverter(jwtAuthConverter))
        );

        return http.build();
    }

    private void exceptionHandler(HttpSecurity http) throws Exception {
        http.exceptionHandling(handle -> handle
                .accessDeniedHandler((req, res, e) ->
                        handleException(res, e, HttpServletResponse.SC_UNAUTHORIZED))
                .authenticationEntryPoint((req, res, e) ->
                        handleException(res, e, HttpServletResponse.SC_FORBIDDEN))
        );
    }

    private void handleException(HttpServletResponse res, Exception e, Integer status)
            throws IOException {

        String message = e.getMessage();

        if (e instanceof InvalidBearerTokenException) {
            if (message.contains("Invalid signature")) {
                message = "Invalid Jwt Token";
            } else if (message.contains("expired")) {
                message = "Token has expired";
                status = HttpServletResponse.SC_METHOD_NOT_ALLOWED;
            }
        }

        res.setContentType("application/json");
        res.setStatus(status);

        CustomResponse customResponse =
                new CustomResponse(null, message, status);

        res.getWriter().println(
                new ObjectMapper().writeValueAsString(customResponse)
        );
    }
}

