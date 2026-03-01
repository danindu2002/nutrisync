package com.y421.nutrisyncservice.entity.nutrisyncUser;

import com.y421.nutrisyncservice.util.audit.AuditModel;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;

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

    // todo: add other fields as necessary
}
