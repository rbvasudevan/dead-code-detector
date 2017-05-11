package com.devfactory.deadcodedetector.domain;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum Status {
    IN_PROGRESS("IN-Progress"),
    ADDED("ADDED"),
    PROCESSING("PROCESSING"),
    COMPLETED("COMPLETED"),
    FAILED("FAILED");

    private String name;

    @Override
    public String toString() {
        return this.getName();
    }
}
