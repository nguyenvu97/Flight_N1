package org.tasc.booking.ticket_Service.controller;

import lombok.RequiredArgsConstructor;
import org.tasc.booking.ticket_Service.dto.Requet.OrderDto;
import org.tasc.booking.ticket_Service.service.TicketService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("api/v1/flight")
public class TicketController {
    private final TicketService ticketService;

    @PostMapping("add")
    public ResponseEntity<?> addTicket(@RequestBody OrderDto ticket){
          return ResponseEntity.ok(ticketService.createTicket(ticket));
    }
    @GetMapping
    public ResponseEntity<?> getTickets(){
        return  ResponseEntity.ok(ticketService.getAll());
    }

    @GetMapping("pay")
    public ResponseEntity<?> getTicket(@RequestParam(value = "orderNo") String  orderNo){
    return  ResponseEntity.ok(ticketService.getOrderNo(orderNo));
    }
    @PostMapping("update")
    public void updateTicket(@RequestParam String orderNo){
          ticketService.update(orderNo);
    }
}
