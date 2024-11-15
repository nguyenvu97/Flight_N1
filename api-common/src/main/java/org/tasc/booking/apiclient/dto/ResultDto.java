package org.tasc.booking.apiclient.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ResultDto {
    private String status;
    private String messger;
    private LocalDateTime date;
    private String url;
}
