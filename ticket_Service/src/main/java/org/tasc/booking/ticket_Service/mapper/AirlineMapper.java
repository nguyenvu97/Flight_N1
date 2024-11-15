package org.tasc.booking.ticket_Service.mapper;

import org.mapstruct.Mapper;
import org.tasc.booking.apiclient.mapper.MapperAll;
import org.tasc.booking.apiclient.mapper.MapperConfig;
import org.tasc.booking.ticket_Service.dto.AirlineDto;
import org.tasc.booking.ticket_Service.entity.Airline;

import java.util.List;

@Mapper(config = MapperConfig.class)
public interface AirlineMapper extends MapperAll<Airline, AirlineDto> {
    @Override
    Airline toDto(AirlineDto airlineDto);

    @Override
    AirlineDto toEntity(Airline airline);

    @Override
    List<Airline> toListEntity(List<AirlineDto> d);

    @Override
    List<AirlineDto> toListDto(List<Airline> e);
}
