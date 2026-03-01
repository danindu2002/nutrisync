package com.y421.nutrisyncservice.util;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Data;

@Data
@JsonIgnoreProperties(ignoreUnknown = true)
public class JwtClaimsDTO {
    private String sub;
    private String sid;
    private Long exp;
}