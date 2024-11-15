package org.tasc.booking.ticket_Service.controller;

import lombok.RequiredArgsConstructor;
import org.tasc.booking.apiclient.ex.NotFound;
import org.tasc.booking.ticket_Service.dto.Requet.SearchFlight;
import org.tasc.booking.ticket_Service.service.FlightService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("api/v1/flight")
public class FlightController {
    public final FlightService flightService;

    @PostMapping("/list")
    public ResponseEntity<?> getFlights(@RequestBody SearchFlight searchFlight , @RequestParam int number){
        try{
            return ResponseEntity.ok(flightService.getData(searchFlight,number));
        }
        catch (NotFound n) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(n.getData());
        }
    }
    @GetMapping("get")
    public ResponseEntity<?> getFlight(@RequestParam int flightId,@RequestParam(required = false) String type_seats ){
        return ResponseEntity.ok(flightService.assets(flightId,type_seats));

    }

}
