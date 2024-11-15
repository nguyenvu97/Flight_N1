package org.tasc.booking.hotel_Service.mapper;

import org.mapstruct.*;
import org.tasc.booking.apiclient.mapper.MapperAll;
import org.tasc.booking.apiclient.mapper.MapperConfig;
import org.tasc.booking.hotel_Service.dto.HotelDto;

import org.tasc.booking.hotel_Service.entity.Hotel;


import java.util.List;

@Mapper(config = MapperConfig.class,
        uses = {ImgMapper.class,
                RoomMapper.class}

)
public interface HotelMapper extends MapperAll<Hotel, HotelDto> {
    @Override
    Hotel toDto(HotelDto hotelDto);



    @Override
    List<Hotel> toListEntity(List<HotelDto> d);

    @Override
    List<HotelDto> toListDto(List<Hotel> e);


    @Override
    @Mappings({
//            @Mapping(target = "count", expression = "Java()")
    })
    HotelDto toEntity(Hotel hotel);


}
