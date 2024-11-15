package org.tasc.booking.hotel_Service.mapper;

import java.util.ArrayList;
import java.util.List;
import javax.annotation.processing.Generated;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.tasc.booking.hotel_Service.dto.HotelDto;
import org.tasc.booking.hotel_Service.entity.Hotel;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2024-11-12T10:30:53+0700",
    comments = "version: 1.5.5.Final, compiler: javac, environment: Java 20.0.1 (Oracle Corporation)"
)
@Component
public class HotelMapperImpl implements HotelMapper {

    @Autowired
    private ImgMapper imgMapper;

    @Override
    public Hotel toDto(HotelDto hotelDto) {
        if ( hotelDto == null ) {
            return null;
        }

        Hotel.HotelBuilder hotel = Hotel.builder();

        hotel.id( hotelDto.getId() );
        hotel.hotelName( hotelDto.getHotelName() );
        hotel.hotelAddress( hotelDto.getHotelAddress() );
        hotel.titleHotel( hotelDto.getTitleHotel() );
        hotel.phoneNumber( hotelDto.getPhoneNumber() );
        hotel.website( hotelDto.getWebsite() );
        hotel.image( imgMapper.toListEntity( hotelDto.getImage() ) );

        return hotel.build();
    }

    @Override
    public List<Hotel> toListEntity(List<HotelDto> d) {
        if ( d == null ) {
            return null;
        }

        List<Hotel> list = new ArrayList<Hotel>( d.size() );
        for ( HotelDto hotelDto : d ) {
            list.add( toDto( hotelDto ) );
        }

        return list;
    }

    @Override
    public List<HotelDto> toListDto(List<Hotel> e) {
        if ( e == null ) {
            return null;
        }

        List<HotelDto> list = new ArrayList<HotelDto>( e.size() );
        for ( Hotel hotel : e ) {
            list.add( toEntity( hotel ) );
        }

        return list;
    }

    @Override
    public HotelDto toEntity(Hotel hotel) {
        if ( hotel == null ) {
            return null;
        }

        HotelDto hotelDto = new HotelDto();

        hotelDto.setId( hotel.getId() );
        hotelDto.setHotelName( hotel.getHotelName() );
        hotelDto.setHotelAddress( hotel.getHotelAddress() );
        hotelDto.setTitleHotel( hotel.getTitleHotel() );
        hotelDto.setPhoneNumber( hotel.getPhoneNumber() );
        hotelDto.setWebsite( hotel.getWebsite() );
        hotelDto.setImage( imgMapper.toListDto( hotel.getImage() ) );

        return hotelDto;
    }
}
