package com.y421.nutrisyncservice.config;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.y421.nutrisyncservice.util.JwtClaimsDTO;
import com.y421.nutrisyncservice.util.JwtDecoder;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.io.PrintWriter;

@Slf4j
@RequiredArgsConstructor
public class KeycloakSessionValidationFilter extends OncePerRequestFilter {

    private final KeycloakSessionService keycloakSessionService;
    private final JwtDecoder jwtDecoder;

    @Override
    protected void doFilterInternal(HttpServletRequest request,@NonNull HttpServletResponse response, @NonNull FilterChain filterChain) throws ServletException, IOException {
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            try {
                String token = authHeader.substring(7);
                JwtClaimsDTO claims = jwtDecoder.getPayloadKeycloak(token);

                if (claims.getSub() == null || claims.getSid() == null || !keycloakSessionService.isSessionActive(claims.getSub(), claims.getSid())) {
                    handleException(response, "Session has been invalidated or user logged out");
                    return;
                }
            } catch (Exception e) {
                log.error("Error validating Keycloak session: {}", e.getMessage(), e);
                handleException(response, "Error validating Keycloak session");
                return;
            }
        }

        filterChain.doFilter(request, response);
    }

    private void handleException(ServletResponse response, String message) throws IOException {
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        httpResponse.setStatus(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        httpResponse.setContentType("application/json");
        CustomResponse customResponse = new CustomResponse(null, message, HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        String jsonResponse = new ObjectMapper().writeValueAsString(customResponse);

        PrintWriter writer = httpResponse.getWriter();
        writer.println(jsonResponse);
    }
}
