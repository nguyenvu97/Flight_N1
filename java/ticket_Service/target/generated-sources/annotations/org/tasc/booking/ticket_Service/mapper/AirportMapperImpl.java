package org.tasc.booking.ticket_Service.mapper;

import java.util.ArrayList;
import java.util.List;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;
import org.tasc.booking.ticket_Service.dto.AirportDto;
import org.tasc.booking.ticket_Service.entity.Airport;
import org.tasc.booking.ticket_Service.entity.Zone;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2024-11-12T10:30:51+0700",
    comments = "version: 1.5.5.Final, compiler: javac, environment: Java 20.0.1 (Oracle Corporation)"
)
@Component
public class AirportMapperImpl implements AirportMapper {

    @Override
    public Airport toDto(AirportDto airportDto) {
        if ( airportDto == null ) {
            return null;
        }

        Airport airport = new Airport();

        airport.setId( (int) airportDto.getId() );
        airport.setCode( airportDto.getCode() );
        airport.setName( airportDto.getName() );

        return airport;
    }

    @Override
    public AirportDto toEntity(Airport airport) {
        if ( airport == null ) {
            return null;
        }

        AirportDto airportDto = new AirportDto();

        airportDto.setLocation( airportZoneName( airport ) );
        airportDto.setId( airport.getId() );
        airportDto.setCode( airport.getCode() );
        airportDto.setName( airport.getName() );

        return airportDto;
    }

    @Override
    public List<Airport> toListEntity(List<AirportDto> d) {
        if ( d == null ) {
            return null;
        }

        List<Airport> list = new ArrayList<Airport>( d.size() );
        for ( AirportDto airportDto : d ) {
            list.add( toDto( airportDto ) );
        }

        return list;
    }

    @Override
    public List<AirportDto> toListDto(List<Airport> e) {
        if ( e == null ) {
            return null;
        }

        List<AirportDto> list = new ArrayList<AirportDto>( e.size() );
        for ( Airport airport : e ) {
            list.add( toEntity( airport ) );
        }

        return list;
    }

    private String airportZoneName(Airport airport) {
        if ( airport == null ) {
            return null;
        }
        Zone zone = airport.getZone();
        if ( zone == null ) {
            return null;
        }
        String name = zone.getName();
        if ( name == null ) {
            return null;
        }
        return name;
    }
}
