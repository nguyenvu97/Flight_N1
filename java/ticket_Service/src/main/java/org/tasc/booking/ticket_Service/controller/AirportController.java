package org.tasc.booking.ticket_Service.controller;

import lombok.RequiredArgsConstructor;
import org.tasc.booking.ticket_Service.service.AirportService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("api/v1/Airport")
public class AirportController {
    private final AirportService airportService;

    @GetMapping("/all")
    public ResponseEntity<?> all() {
        return ResponseEntity.ok(airportService.getLocal());
    }
}
