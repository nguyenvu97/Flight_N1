package org.tasc.booking.ticket_Service.dto.Requet;

import lombok.*;
import org.tasc.booking.apiclient.dto.CustomerDto;

import java.util.List;
@Data
public class OrderDto {
    public List<Integer> flight_go;
    public List<Integer> flight_back;
    public List<CustomerDto>customers;
    public boolean ticketTypeGo;
    public boolean ticketTypeBack;

}
