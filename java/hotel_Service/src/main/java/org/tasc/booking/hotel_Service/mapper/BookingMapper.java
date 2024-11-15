package org.tasc.booking.hotel_Service.mapper;

import org.mapstruct.Mapper;
import org.tasc.booking.apiclient.mapper.MapperAll;
import org.tasc.booking.apiclient.mapper.MapperConfig;
import org.tasc.booking.hotel_Service.dto.BookingDto;
import org.tasc.booking.hotel_Service.entity.Booking;

import java.util.List;

@Mapper(config = MapperConfig.class,
        uses = {ImgMapper.class, RoomMapper.class,HotelMapper.class}
)

public interface BookingMapper extends MapperAll<Booking, BookingDto> {

    @Override
    Booking toDto(BookingDto bookingDto);

    @Override
    BookingDto toEntity(Booking booking);

    @Override
    List<Booking> toListEntity(List<BookingDto> d);

    @Override
    List<BookingDto> toListDto(List<Booking> e);

}
