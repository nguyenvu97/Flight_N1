package org.tasc.booking.hotel_Service.dto;

import lombok.Data;

import java.util.Date;

@Data
public class ReviewDto {
    private long id;
    private long hotelId;
    private String email;
    private Long customerId;
    private String comment;
    private int rating;
    private Date time;
}
