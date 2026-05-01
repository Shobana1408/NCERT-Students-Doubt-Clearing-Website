package com.ncert.doubtsolver.service;

/**
 * Thrown when the Flask microservice returns an error payload or a non-success HTTP status.
 */
public class FlaskIntegrationException extends Exception {

    private final int httpStatus;

    public FlaskIntegrationException(String message) {
        super(message);
        this.httpStatus = 0;
    }

    public FlaskIntegrationException(String message, Throwable cause) {
        super(message, cause);
        this.httpStatus = 0;
    }

    public FlaskIntegrationException(String message, int httpStatus) {
        super(message);
        this.httpStatus = httpStatus;
    }

    public int getHttpStatus() {
        return httpStatus;
    }
}
