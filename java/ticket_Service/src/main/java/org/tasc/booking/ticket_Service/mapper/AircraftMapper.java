package org.tasc.booking.ticket_Service.mapper;

import org.mapstruct.Mapper;
import org.tasc.booking.apiclient.mapper.MapperAll;
import org.tasc.booking.apiclient.mapper.MapperConfig;
import org.tasc.booking.ticket_Service.dto.AircraftDto;
import org.tasc.booking.ticket_Service.entity.Aircraft;

import java.util.List;

@Mapper(config = MapperConfig.class)
public interface AircraftMapper extends MapperAll<Aircraft, AircraftDto> {
    @Override
    Aircraft toDto(AircraftDto aircraftDto);

    @Override
    AircraftDto toEntity(Aircraft aircraft);

    @Override
    List<Aircraft> toListEntity(List<AircraftDto> d);

    @Override
    List<AircraftDto> toListDto(List<Aircraft> e);
}
