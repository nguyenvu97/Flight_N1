package org.tasc.booking.apiclient.ex;

import lombok.*;

@Getter
@Setter
@AllArgsConstructor
public class Exception extends RuntimeException{

    private String message;

    private int statusCode;
}
