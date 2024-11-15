package org.tasc.booking.apiclient.ex;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.io.Serializable;
import java.time.Instant;

@Data
@Builder
@AllArgsConstructor
public class ErrorMessageDTO   {
    private String message;
    private Instant date;
    private int statusCode;

}
