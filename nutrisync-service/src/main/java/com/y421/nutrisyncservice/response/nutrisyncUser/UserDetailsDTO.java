package com.y421.nutrisyncservice.response.nutrisyncUser;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserDetailsDTO {
    private Long userId;
    private String firstName;
    private String LastName;
    private String email;
    private Integer age;
    private String gender;
    private Float bmi;
    private String activityLevel;
    private Integer dailyCalorieGoal;
    private Integer points;
    private LocalDateTime premiumExpireDate;
    private byte[] profileImage;

    private Integer completedChallenges;
    private Integer activeChallenges;
    private Integer failedChallenges;
    private Integer score;
}
