package org.tasc.booking.ticket_Service.dto.Response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FlightResponse {
    List<FlightDto> flight_go = new ArrayList<>();
     List<FlightDto> flight_back = new ArrayList<>();
    public int adultQuantity;
    public int childQuantity;
}
