package com.y421.nutrisyncservice.request.nutrisyncUser;

import lombok.Data;
import org.springframework.web.multipart.MultipartFile;

import java.util.Date;

@Data
public class UpdateProfileRequestDto {

    private String firstName;
    private String lastName;
    private String email;
    private Date dob;

    // For image upload
    private MultipartFile profileImage;
}