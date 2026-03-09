package com.y421.nutrisyncservice.entity.nutrisyncUser;

import com.y421.nutrisyncservice.util.audit.AuditModel;
import com.y421.nutrisyncservice.util.jsonConverter.MealTimesConverter;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Table(name = "M_NUTRISYNC_USER")
public class NutrisyncUser extends AuditModel implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "M_NUTRISYNC_USER")
    @SequenceGenerator(sequenceName = "M_NUTRISYNC_USER_SEQ", allocationSize = 1, name = "M_NUTRISYNC_USER")
    @Column(name = "USER_ID", nullable = false)
    private Long userId;

    @Column(name = "FIRST_NAME", nullable = false)
    private String firstName;

    @Column(name = "LAST_NAME", nullable = false)
    private String lastName;

    @Column(name = "PASSWORD", nullable = false)
    private String password;

    @Column(name = "EMAIL", nullable = false)
    private String email;

    @Column(name = "DATE_OF_BIRTH", nullable = true)
    private Date dateOfBirth;

    @Column(name = "GENDER", nullable = true)
    private String gender;

    @Column(name = "AGE", nullable = true)
    private Integer age;

    @Column(name = "HEIGHT_CM", nullable = true)
    private Float heightCm;

    @Column(name = "WEIGHT_KG", nullable = true)
    private Float weightKg;

    @Column(name = "BMI", nullable = true)
    private Float bmi;

    @Column(name = "ACTIVITY_LEVEL", nullable = true)
    private String activityLevel;

    @Column(name = "GOAL_SPEED", nullable = true)
    private String goalSpeed;

    @Column(name = "DIETARY_PREFERENCES", nullable = true)
    private List<String> dietaryPreferences;

    @Column(name = "MEAL_TIMES", nullable = true, columnDefinition = "JSON")
    @Convert(converter = MealTimesConverter.class)
    private Map<String, String> mealTimes;

    @Column(name = "ALLERGIES", nullable = true)
    private List<String> allergies;

    @Column(name = "MEDICAL_CONDITIONS", nullable = true)
    private List<String> medicalConditions;

    @Column(name = "DAILY_CALORIE_GOAL", nullable = true)
    private Integer dailyCalorieGoal;

    @Column(name = "SLEEP_QUALITY", nullable = true)
    private String sleepQuality;

    @Column(name = "FITNESS_GOAL", nullable = true)
    private String fitnessGoal;

    @Column(name = "GOAL_MOTIVATION", nullable = true)
    private String goalMotivation;

    @Column(name = "REG_DATE", nullable = false)
    private Date regDate;// user registered date

    @Column(name = "IS_DELETED", nullable = false)
    private Boolean isDeleted = false;

    @Column(name = "KEYCLOAK_USER_ID", nullable = false)
    private String keycloakUserId;

    @Column(name = "FORGOT_PWD_OTP", nullable = true)
    private String forgotPwdOtp;

    @Column(name = "USER_NAME", nullable = false)
    private String userName;

    // todo: add other fields as necessary
}
