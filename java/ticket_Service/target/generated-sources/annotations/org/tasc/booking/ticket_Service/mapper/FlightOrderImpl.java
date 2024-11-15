package org.tasc.booking.ticket_Service.mapper;

import java.util.ArrayList;
import java.util.List;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;
import org.tasc.booking.apiclient.dto.FlightTickitDto;
import org.tasc.booking.ticket_Service.dto.Response.FlightDto;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2024-11-12T10:30:51+0700",
    comments = "version: 1.5.5.Final, compiler: javac, environment: Java 20.0.1 (Oracle Corporation)"
)
@Component
public class FlightOrderImpl implements FlightOrder {

    @Override
    public FlightTickitDto toEntity(FlightDto flightDto) {
        if ( flightDto == null ) {
            return null;
        }

        FlightTickitDto flightTickitDto = new FlightTickitDto();

        flightTickitDto.setId( flightDto.getId() );
        flightTickitDto.setFromCity( flightDto.getFromCity() );
        flightTickitDto.setToCity( flightDto.getToCity() );
        flightTickitDto.setDepartureTime( flightDto.getDepartureTime() );
        flightTickitDto.setArrivalTime( flightDto.getArrivalTime() );
        flightTickitDto.setBasePrice( flightDto.getBasePrice() );
        flightTickitDto.setCode( flightDto.getCode() );
        flightTickitDto.setFlights( flightDtoListToFlightTickitDtoList( flightDto.getFlights() ) );

        return flightTickitDto;
    }

    protected List<FlightTickitDto> flightDtoListToFlightTickitDtoList(List<FlightDto> list) {
        if ( list == null ) {
            return null;
        }

        List<FlightTickitDto> list1 = new ArrayList<FlightTickitDto>( list.size() );
        for ( FlightDto flightDto : list ) {
            list1.add( toEntity( flightDto ) );
        }

        return list1;
    }
}
