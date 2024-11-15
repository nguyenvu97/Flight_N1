package org.tasc.booking.apiclient.ticket;


import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.*;
import org.tasc.booking.apiclient.dto.Ticket;

import java.util.List;
import java.util.Set;

@FeignClient(name = "ticket",url = "http://localhost:1002/")
@Repository
public interface TicketApi {

    @GetMapping("api/v1/flight/pay")
    Ticket get(@RequestParam(value = "orderNo") String orderNo);

    @PostMapping("api/v1/flight/update")
    void update(@RequestParam(value = "orderNo") String orderNo);

    @DeleteMapping("api/v1/assets")
    void delete(@RequestParam(value ="flightId" ) long flightId,@RequestParam(value = "assets" ) List<String> assets);

}
