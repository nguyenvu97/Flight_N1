package org.tasc.booking.ticket_Service.mapper;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.tasc.booking.apiclient.mapper.MapperAll;
import org.tasc.booking.apiclient.mapper.MapperConfig;
import org.tasc.booking.ticket_Service.dto.AirportDto;
import org.tasc.booking.ticket_Service.entity.Airport;

import java.util.List;


@Mapper(config = MapperConfig.class)

public interface AirportMapper extends MapperAll<Airport, AirportDto> {
    @Override
    Airport toDto(AirportDto airportDto);

    @Override
    @Mappings({
            @Mapping(source = "airport.zone.name" ,target = "location" )
    })
    AirportDto toEntity(Airport airport);

    @Override
    List<Airport> toListEntity(List<AirportDto> d);

    @Override
    List<AirportDto> toListDto(List<Airport> e);
}
