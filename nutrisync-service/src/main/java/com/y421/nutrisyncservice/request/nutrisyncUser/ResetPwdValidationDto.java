package com.y421.nutrisyncservice.request.nutrisyncUser;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ResetPwdValidationDto {
    private String email;
    private String otp;
}
