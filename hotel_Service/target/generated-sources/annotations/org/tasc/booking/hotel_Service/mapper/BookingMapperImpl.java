package org.tasc.booking.hotel_Service.mapper;

import java.util.ArrayList;
import java.util.List;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;
import org.tasc.booking.hotel_Service.dto.BookingDto;
import org.tasc.booking.hotel_Service.entity.Booking;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2024-11-12T10:30:53+0700",
    comments = "version: 1.5.5.Final, compiler: javac, environment: Java 20.0.1 (Oracle Corporation)"
)
@Component
public class BookingMapperImpl implements BookingMapper {

    @Override
    public Booking toDto(BookingDto bookingDto) {
        if ( bookingDto == null ) {
            return null;
        }

        Booking.BookingBuilder booking = Booking.builder();

        booking.id( bookingDto.getId() );
        booking.orderNo( bookingDto.getOrderNo() );
        booking.bookingDate( bookingDto.getBookingDate() );
        booking.checkInDate( bookingDto.getCheckInDate() );
        booking.checkOutDate( bookingDto.getCheckOutDate() );
        booking.numberPeople( bookingDto.getNumberPeople() );
        booking.totalPrice( bookingDto.getTotalPrice() );
        booking.quantityRoom( bookingDto.getQuantityRoom() );
        booking.stayNight( bookingDto.getStayNight() );
        booking.userName( bookingDto.getUserName() );
        booking.email( bookingDto.getEmail() );
        booking.phoneNumber( bookingDto.getPhoneNumber() );
        booking.roomId( bookingDto.getRoomId() );
        booking.bookingStatus( bookingDto.getBookingStatus() );
        booking.hotelId( bookingDto.getHotelId() );
        booking.roomCategory( bookingDto.getRoomCategory() );
        booking.hotelName( bookingDto.getHotelName() );

        return booking.build();
    }

    @Override
    public BookingDto toEntity(Booking booking) {
        if ( booking == null ) {
            return null;
        }

        BookingDto bookingDto = new BookingDto();

        bookingDto.setId( booking.getId() );
        bookingDto.setOrderNo( booking.getOrderNo() );
        bookingDto.setBookingDate( booking.getBookingDate() );
        bookingDto.setCheckInDate( booking.getCheckInDate() );
        bookingDto.setCheckOutDate( booking.getCheckOutDate() );
        bookingDto.setNumberPeople( booking.getNumberPeople() );
        bookingDto.setTotalPrice( booking.getTotalPrice() );
        bookingDto.setQuantityRoom( booking.getQuantityRoom() );
        bookingDto.setStayNight( booking.getStayNight() );
        bookingDto.setUserName( booking.getUserName() );
        bookingDto.setEmail( booking.getEmail() );
        bookingDto.setPhoneNumber( booking.getPhoneNumber() );
        bookingDto.setRoomId( booking.getRoomId() );
        bookingDto.setBookingStatus( booking.getBookingStatus() );
        bookingDto.setHotelId( booking.getHotelId() );
        bookingDto.setRoomCategory( booking.getRoomCategory() );
        bookingDto.setHotelName( booking.getHotelName() );

        return bookingDto;
    }

    @Override
    public List<Booking> toListEntity(List<BookingDto> d) {
        if ( d == null ) {
            return null;
        }

        List<Booking> list = new ArrayList<Booking>( d.size() );
        for ( BookingDto bookingDto : d ) {
            list.add( toDto( bookingDto ) );
        }

        return list;
    }

    @Override
    public List<BookingDto> toListDto(List<Booking> e) {
        if ( e == null ) {
            return null;
        }

        List<BookingDto> list = new ArrayList<BookingDto>( e.size() );
        for ( Booking booking : e ) {
            list.add( toEntity( booking ) );
        }

        return list;
    }
}
