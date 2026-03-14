package com.y421.nutrisyncservice.request.nutrisyncUser;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ResetPwdDto {
    private String email;
    private String newPassword;
    private String otp;
}
