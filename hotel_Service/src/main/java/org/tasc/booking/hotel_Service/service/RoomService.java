package org.tasc.booking.hotel_Service.service;

import org.tasc.booking.hotel_Service.dto.RoomDto;
import org.tasc.booking.hotel_Service.entity.Enum.CategoryType;
import org.tasc.booking.hotel_Service.entity.Room;
import org.tasc.booking.hotel_Service.projection.RoomData;

import java.util.List;

public interface RoomService {
    String add(List<Room> room,long hotelId);
    List<RoomDto>findByHotelId(Long hotelId);

    RoomData countRoomsByHotelId(Long hotelId, CategoryType categoryType, int numberPeople, int numberRoom, String startTime, String endTime) ;
}
