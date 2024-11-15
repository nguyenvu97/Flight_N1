package org.tasc.booking.apiclient.dto;

import lombok.Builder;
import lombok.Data;
import org.springframework.http.HttpStatusCode;

@Data
@Builder
public class ResponseDto  {
    private int statusCode;
    private String message;
    private Object data;
}
