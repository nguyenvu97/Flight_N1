package org.tasc.booking.hotel_Service.mapper;

import org.mapstruct.Mapper;
import org.tasc.booking.apiclient.mapper.MapperAll;
import org.tasc.booking.apiclient.mapper.MapperConfig;
import org.tasc.booking.hotel_Service.dto.RoomDto;
import org.tasc.booking.hotel_Service.entity.Room;

import java.util.List;

@Mapper(config = MapperConfig.class
)
public interface RoomMapper extends MapperAll<Room, RoomDto> {
    @Override
    Room toDto(RoomDto roomDto);

    @Override
    RoomDto toEntity(Room room);

    @Override
    List<Room> toListEntity(List<RoomDto> d);

    @Override
    List<RoomDto> toListDto(List<Room> e);
}
