package org.tasc.booking.hotel_Service.controller;

import lombok.RequiredArgsConstructor;
import org.tasc.booking.apiclient.ex.NotFound;
import org.tasc.booking.hotel_Service.dto.ReviewDto;
import org.tasc.booking.hotel_Service.service.ReviewService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
@RequestMapping("api/v1/review")
public class ReviewController {
    public final ReviewService reviewService;
    @PostMapping("/add")
    public ResponseEntity<String> createReview(@RequestBody ReviewDto review ) {
        try {
            reviewService.createReview(review);
            return ResponseEntity.ok("Review created successfully");
        } catch (NotFound e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An error occurred");
        }
    }
    @GetMapping("/hotel")
    public ResponseEntity<?> getReviews(
            @RequestParam("hotelId") long hotelId, @RequestParam(value = "pageNumber",defaultValue = "0") int pageNumber
            ) {
        try {
            return ResponseEntity.ok(reviewService.getReviews(hotelId,pageNumber));
        } catch (NotFound e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An error occurred");
        }
    }
    @GetMapping("/start_sequentially")
    public ResponseEntity<?> start_Sequentially(
            @RequestParam("hotelId") long hotelId
    ) {
        try {
            return ResponseEntity.ok(reviewService.start_Sequentially(hotelId));
        } catch (NotFound e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getData());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("An error occurred");
        }
    }
}
