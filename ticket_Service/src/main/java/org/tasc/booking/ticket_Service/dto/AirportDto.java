package org.tasc.booking.ticket_Service.dto;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@NoArgsConstructor
@AllArgsConstructor
@Data
public class AirportDto {
    private long id;
    private String location;
    private String code;
    private String name;
}
