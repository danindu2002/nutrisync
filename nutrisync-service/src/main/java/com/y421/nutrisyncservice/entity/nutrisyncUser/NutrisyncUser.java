package com.y421.nutrisyncservice.entity.nutrisyncUser;

import com.y421.nutrisyncservice.util.audit.AuditModel;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

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

    @Column(name = "DATE_OF_BIRTH", nullable = false)
    private Date dateOfBirth;

    @Column(name = "GENDER", nullable = false)
    private String gender;

    @Column(name = "AGE", nullable = false)
    private Integer age;

    @Column(name = "HEIGHT", nullable = false)
    private Float height;

    @Column(name = "WEIGHT", nullable = false)
    private Float weight;

    @Column(name = "BMI", nullable = false)
    private Float bmi;

    @Column(name = "ACTIVITY_LEVEL", nullable = false)
    private String activityLevel;

    @Column(name = "DIETARY_PREFERENCES", nullable = false)
    private List<String> dietaryPreferences;

    @Column(name = "REG_DATE", nullable = false)
    private Date regDate;// user registered date

    // todo: add other fields as necessary
}
