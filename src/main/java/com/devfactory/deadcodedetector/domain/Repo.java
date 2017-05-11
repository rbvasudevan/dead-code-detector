package com.devfactory.deadcodedetector.domain;

import java.time.ZonedDateTime;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;

@Entity
@Getter
@Setter
@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Repo {

    @Id
    @GeneratedValue
    private Long id;

    @Column(nullable = false, length = 512)
    private String repoId;


    @Column(nullable = false, length = 512)
    private String repoUrl;

    @Column(nullable = false)
    private Status status;

    @Column
    private String exception;

    @Column
    private String repoLocalLocation;

    @Column
    private String udbPath;

    @Column
    private String reportFolder;

    @CreatedDate
    @Column(nullable = false)
    private ZonedDateTime createdAt;

    @LastModifiedDate
    @Column
    private ZonedDateTime updatedAt;

    @PrePersist
    protected void onCreate()
    {
        createdAt=updatedAt=ZonedDateTime.now();
    }
    @PreUpdate
    protected void onUpdate(){
        updatedAt=ZonedDateTime.now();
    }

}
