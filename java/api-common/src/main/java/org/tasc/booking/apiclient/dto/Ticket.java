package org.tasc.booking.apiclient.dto;

import lombok.*;
import org.springframework.data.mongodb.core.mapping.Document;
import java.util.List;
import org.springframework.data.annotation.Id;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Document()
@Builder
public class Ticket {
    @Id
    private String id;
    private String orderNo;
    private String OrderStatus;
    private String ticketTypeGo;
    private String ticketTypeBack;
    private double totalTicket;
    private String ticketType;
    private List<CustomerDto>customers;
    private FlightTickitDto flights_go;
    private FlightTickitDto flights_back ;

}
