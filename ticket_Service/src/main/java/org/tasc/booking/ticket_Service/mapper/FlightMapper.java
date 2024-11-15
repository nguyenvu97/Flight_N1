package org.tasc.booking.ticket_Service.mapper;


import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.tasc.booking.apiclient.mapper.MapperAll;
import org.tasc.booking.apiclient.mapper.MapperConfig;
import org.tasc.booking.ticket_Service.dto.Response.FlightDto;
import org.tasc.booking.ticket_Service.entity.Flight;

import java.util.List;

@Mapper(config = MapperConfig.class,uses = {
        AircraftMapper.class,
        AirlineMapper.class})
public interface FlightMapper  extends MapperAll<Flight, FlightDto> {
    @Override
    Flight toDto(FlightDto flightResponse);

    @Mappings({

            @Mapping(source = "flightSegment.aircraft.totalSeats",target = "totalSeats"),
            @Mapping(source = "flightSegment.aircraft.economySeats",target = "economySeats"),
            @Mapping(source = "flightSegment.aircraft.businessSeats",target = "businessSeats"),
            @Mapping(source = "flightSegment.aircraft.airline.name",target = "airline"),
            @Mapping(source = "flightSegment.subsequentSegments", target = "flights")

    })
    FlightDto toEntity(Flight flightSegment);


    @Mappings({
            @Mapping(source = "flightSegment.aircraft.totalSeats", target = "totalSeats"),
            @Mapping(source = "flightSegment.aircraft.economySeats", target = "economySeats"),
            @Mapping(source = "flightSegment.aircraft.businessSeats", target = "businessSeats"),
            @Mapping(source = "flightSegment.aircraft.airline.name", target = "airline"),
            @Mapping(target = "flights", expression = "java(null)")
    })
    FlightDto toEntityWithNoFlights(Flight flightSegment, String data);



    @Override
    List<Flight> toListEntity(List<FlightDto> d);

    @Override

    List<FlightDto> toListDto(List<Flight> e);


}


