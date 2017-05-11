package com.devfactory.deadcodedetector.config;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Getter
@Setter
@Builder
@Configuration
@NoArgsConstructor
@AllArgsConstructor
@ConfigurationProperties(prefix = "dead-code-detector")
public class DeadCodeDetectorProperties {

    private String understandHome;
    private String localBaseLocation;
    private String executionCommand;

}
