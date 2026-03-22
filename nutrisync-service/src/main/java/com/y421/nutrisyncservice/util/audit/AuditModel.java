package com.y421.nutrisyncservice.util.audit;

import jakarta.persistence.Column;
import jakarta.persistence.EntityListeners;
import jakarta.persistence.MappedSuperclass;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedBy;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.util.Date;

@MappedSuperclass
@EntityListeners({AuditingEntityListener.class})
@AllArgsConstructor
@NoArgsConstructor
@Data
public class AuditModel {

    @CreatedBy
    @Column(
            name = "CREATED_BY",
            updatable = false
    )
    private String createdBy;
    @CreatedDate
    @Column(
            name = "CREATED_ON",
            updatable = false
    )
    private Date createdOn;
    @LastModifiedBy
    @Column(
            name = "UPDATED_BY"
    )
    private String updatedBy;
    @LastModifiedDate
    @Column(
            name = "UPDATED_ON"
    )
    private Date updatedOn;
}
