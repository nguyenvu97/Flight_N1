package org.tasc.booking.apiclient.ex;

public class InvalidCallException extends Exception {
    public InvalidCallException(String message,int statusCode) {
       super(message,statusCode);
    }
}
