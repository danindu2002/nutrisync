package com.y421.nutrisyncservice.request.nutrisyncUser;

import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

@Data
public class UpdateProfileRequestDto {

    private String firstName;
    private String lastName;
    private String email;

    // For image upload
    private MultipartFile profileImage;
}