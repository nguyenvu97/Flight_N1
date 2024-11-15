package org.tasc.booking.ticket_Service.mapper;

import java.util.ArrayList;
import java.util.List;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;
import org.tasc.booking.ticket_Service.dto.AirlineDto;
import org.tasc.booking.ticket_Service.entity.Airline;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2024-11-12T10:30:51+0700",
    comments = "version: 1.5.5.Final, compiler: javac, environment: Java 20.0.1 (Oracle Corporation)"
)
@Component
public class AirlineMapperImpl implements AirlineMapper {

    @Override
    public Airline toDto(AirlineDto airlineDto) {
        if ( airlineDto == null ) {
            return null;
        }

        Airline.AirlineBuilder airline = Airline.builder();

        airline.id( airlineDto.getId() );
        airline.name( airlineDto.getName() );
        airline.code( airlineDto.getCode() );
        airline.note( airlineDto.getNote() );

        return airline.build();
    }

    @Override
    public AirlineDto toEntity(Airline airline) {
        if ( airline == null ) {
            return null;
        }

        AirlineDto airlineDto = new AirlineDto();

        airlineDto.setId( airline.getId() );
        airlineDto.setName( airline.getName() );
        airlineDto.setCode( airline.getCode() );
        airlineDto.setNote( airline.getNote() );

        return airlineDto;
    }

    @Override
    public List<Airline> toListEntity(List<AirlineDto> d) {
        if ( d == null ) {
            return null;
        }

        List<Airline> list = new ArrayList<Airline>( d.size() );
        for ( AirlineDto airlineDto : d ) {
            list.add( toDto( airlineDto ) );
        }

        return list;
    }

    @Override
    public List<AirlineDto> toListDto(List<Airline> e) {
        if ( e == null ) {
            return null;
        }

        List<AirlineDto> list = new ArrayList<AirlineDto>( e.size() );
        for ( Airline airline : e ) {
            list.add( toEntity( airline ) );
        }

        return list;
    }
}
