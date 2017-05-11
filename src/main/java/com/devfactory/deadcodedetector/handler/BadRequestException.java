package com.devfactory.deadcodedetector.handler;

public class BadRequestException extends IllegalArgumentException {

    private static final long serialVersionUID = 1L;

    public BadRequestException(String errorMessage) {
        super(errorMessage);
    }
}
