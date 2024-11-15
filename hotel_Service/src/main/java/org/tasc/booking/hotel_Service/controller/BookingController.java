package org.tasc.booking.hotel_Service.controller;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.tasc.booking.apiclient.ex.NotFound;
import org.tasc.booking.hotel_Service.entity.Booking;
import org.tasc.booking.hotel_Service.service.BookService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("api/v1/booking")
@Slf4j
public class BookingController {
    private final BookService bookService;



    @PostMapping()
    public ResponseEntity<?> add (@RequestBody Booking booking, @RequestParam long roomId) {
        try {
            return ResponseEntity.ok().body(bookService.add(booking, roomId));

        }catch (NotFound e){
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getData());
        }
    }

    @PostMapping("/add/with_token")
    public ResponseEntity<?> addBookingWith_token(@RequestBody Booking booking, @RequestParam long roomId,@RequestHeader(value = "Authorization")String token) {
        try {
            return ResponseEntity.ok().body(bookService.add(booking, roomId,token));

        }catch (NotFound e){
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getData());
        }
    }


    @PostMapping("/_search")
    public ResponseEntity<?> search( @RequestParam String orderNo) {
        try {
            return ResponseEntity.ok().body(bookService.search(orderNo));

        }catch (NotFound e){
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }
}
