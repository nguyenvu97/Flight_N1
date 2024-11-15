package org.tasc.booking.apiclient.ex;

public class EntityNotFound extends Exception {
    public EntityNotFound(String message, int statusCode) {
        super(message,statusCode);
    }
}
