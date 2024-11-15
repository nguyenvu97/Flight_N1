package org.tasc.booking.ticket_Service.service;

import org.tasc.booking.ticket_Service.dto.Requet.OrderDto;
import org.tasc.booking.apiclient.dto.Ticket;

import java.util.List;
import java.util.Set;


public interface TicketService {

    Ticket createTicket(OrderDto ticket);

    List<Ticket> getAll();

   Ticket getOrderNo(String orderNo);
    void update(String orderNo);


}
