package com.y421.nutrisyncservice.util.audit;

import com.y421.nutrisyncservice.util.YamlConfig;
import lombok.NonNull;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.domain.AuditorAware;

import java.util.Optional;

@Configuration
@RequiredArgsConstructor
public class JpaAuditProvider implements AuditorAware<String> {

    private final YamlConfig yamlConfig;

    @Override
    @NonNull
    public Optional<String> getCurrentAuditor() {
        return Optional.of(yamlConfig.getUserId() != null ? yamlConfig.getUserId() : "SYSTEM");
    }
}
