package org.tasc.booking.hotel_Service.dto;

import lombok.*;

import java.util.List;



@Setter
@Getter
public class HotelDto {
    private long id;
    private String hotelName;
    private String hotelAddress;
    private String titleHotel;
    private String phoneNumber;
    private double stars;
    private int countReviews;
    private String website;
    private List<ImageDto> image;
    private int count;
    private double price;
    private String category;
    private long roomId;


}
