package org.tasc.booking.ticket_Service.dto;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AirlineDto {
    private int id;

    private String name;

    private String code;
    private String note;
}
