package org.tasc.booking.ticket_Service.mapper;

import org.mapstruct.Mapper;
import org.tasc.booking.apiclient.mapper.MapperConfig;
import org.tasc.booking.apiclient.dto.FlightTickitDto;
import org.tasc.booking.ticket_Service.dto.Response.FlightDto;

@Mapper(config = MapperConfig.class)
public interface FlightOrder   {
    FlightTickitDto toEntity(FlightDto flightDto);
}
