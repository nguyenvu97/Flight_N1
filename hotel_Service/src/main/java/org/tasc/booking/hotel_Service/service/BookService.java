package org.tasc.booking.hotel_Service.service;

import org.tasc.booking.hotel_Service.dto.BookingDto;
import org.tasc.booking.hotel_Service.entity.Booking;

import java.util.List;


public interface BookService {

    BookingDto add(Booking booking, long roomId);
    BookingDto add(Booking booking, long roomId,String jwt);
    List<BookingDto> search(String orderNo);

}
