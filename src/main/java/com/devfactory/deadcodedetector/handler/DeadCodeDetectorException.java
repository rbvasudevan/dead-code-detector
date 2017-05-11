package com.devfactory.deadcodedetector.handler;

public class DeadCodeDetectorException extends RuntimeException {

    public DeadCodeDetectorException(String message, Throwable cause) {
        super(message, cause);
    }
}
