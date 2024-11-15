package org.tasc.booking.hotel_Service.dto;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RoomDto {
    private long id;
    private double price;
    private int numberPeople;
    private int numberRoom;
    private String categoryType;
    private String roomStatus;
}
