package org.tasc.booking.ticket_Service.dto.Response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;

@Data
@NoArgsConstructor
@AllArgsConstructor

public class FlightDto {

    private int id;

    private String fromCity;

    private String toCity;

    private LocalDateTime departureTime;

    private LocalDateTime arrivalTime;

    private BigDecimal basePrice;

    private int reservedSeats;

    private int reservedBusinessSeats;

    private int economySeats;

    private int businessSeats;

    private int totalSeats;

//    private int order;

    private String code;

    private String airline;
    
    private Set<String> seats;

    private List<FlightDto> flights;





}
