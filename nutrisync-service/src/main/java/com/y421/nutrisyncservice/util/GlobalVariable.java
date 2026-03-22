package com.y421.nutrisyncservice.util;

import lombok.Data;
import org.springframework.stereotype.Component;

@Data
@Component
public class GlobalVariable {
    private String userId;
    private String jwtToken;
}
