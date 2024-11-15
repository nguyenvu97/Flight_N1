package org.tasc.booking.hotel_Service.service.impl;

import lombok.RequiredArgsConstructor;
import org.tasc.booking.apiclient.auth.Jwt;
import org.tasc.booking.apiclient.dto.MemberData;
import org.tasc.booking.apiclient.ex.NotFound;
import org.tasc.booking.hotel_Service.dto.BookingDto;
import org.tasc.booking.hotel_Service.entity.Booking;
import org.tasc.booking.hotel_Service.entity.Enum.BookingStatus;
import org.tasc.booking.hotel_Service.entity.Room;
import org.tasc.booking.hotel_Service.mapper.BookingMapper;
import org.tasc.booking.hotel_Service.repository.BookingRepository;
import org.tasc.booking.hotel_Service.repository.HotelRepository;
import org.tasc.booking.hotel_Service.repository.RoomRepository;
import org.tasc.booking.hotel_Service.service.BookService;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;
import java.util.Random;

@Service
@RequiredArgsConstructor
@Transactional(rollbackFor = Exception.class)
public class BookServiceImpl implements BookService {
    private final BookingRepository bookingRepository;
    private final HotelRepository hotelRepository;
    private final RoomRepository roomRepository;
    private final BookingMapper bookingMapper;
    private final Jwt jwt;

    @Override
    @Async
    public BookingDto add(Booking booking, long roomId) {
        if ( !hotelRepository.existsById(booking.getHotelId())){
            throw new NotFound("Hotel Not Found");
        }
        if (roomId< 0){
            throw new NotFound("Room Not Found");
        }

        String orderNo = orderNo();
            Date now = new Date();
            Room room =  roomRepository.findById(roomId).orElseThrow(()->new NotFound("Room Not Found"));

            int date = booking.getCheckOutDate().getDate() -booking.getCheckInDate().getDate()-1 ;
            Booking booking1 =bookingRepository.save(Booking
                            .builder()
                            .bookingDate(now)
                            .stayNight(date)
                            .bookingStatus(BookingStatus.CONFIRMED)
                            .checkInDate(booking.getCheckInDate())
                            .checkOutDate(booking.getCheckOutDate())
                            .hotelId(booking.getHotelId())
                            .roomId(room.getId())
                            .quantityRoom(room.getNumberRoom())
                            .totalPrice(room.getPrice() * booking.getQuantityRoom() * date)
                            .numberPeople(booking.getNumberPeople())
                            .orderNo(orderNo)
                            .email(booking.getEmail())
                            .phoneNumber(booking.getPhoneNumber())
                            .userName(booking.getUserName())
                            .roomCategory(booking.getRoomCategory())
                            .hotelName(booking.getHotelName())
                            .build());

        return bookingMapper.toEntity(booking1);


    }

    @Override
    @Async
    public BookingDto add(Booking booking, long roomId, String token) {
        MemberData memberData = jwt.decode(token);
        if (memberData == null){
            throw new NotFound("Invalid token");
        }
        return add(booking,roomId);
    }

    @Override
    @Async
    public List<BookingDto> search(String orderNo) {
        if (orderNo.isEmpty()){
            throw new NotFound("Order Not Found");
        }
        return bookingRepository.findByOrderNo(orderNo);
    }

    private String orderNo(){
        Random random = new Random();
        return "orderNo"+random.nextInt(10000);
    }
}
