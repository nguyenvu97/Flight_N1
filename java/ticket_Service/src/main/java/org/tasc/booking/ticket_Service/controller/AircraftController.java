package org.tasc.booking.ticket_Service.controller;

import lombok.RequiredArgsConstructor;
import org.tasc.booking.ticket_Service.service.AircraftService;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@RequestMapping("api/v1")
public class AircraftController {
    private final AircraftService aircraftService;
}
