package com.y421.nutrisyncservice.request.nutrisyncUser;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class NutrisyncUserRequestDto {
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private Date dateOfBirth;
    private String gender;
    private Integer age;
    private Float height;
    private Float weight;
    private Float bmi;
    private String activityLevel;
    private List<String> dietaryPreferences;
    private Date regDate;
}
