package org.tasc.booking.hotel_Service.dto.request;

import lombok.Getter;
import lombok.Setter;
import org.tasc.booking.hotel_Service.dto.PagingDto;
import org.tasc.booking.hotel_Service.entity.Enum.CategoryType;

@Setter
@Getter
public class HotelSearch extends PagingDto {
    private  String address;
    private int numberPeople;
    private int numberRoom;
    private CategoryType categoryType;
    private double minMoney;
    private double maxMoney;
    private int startHotel;
    private String startTime;
    private String endTime;


}
