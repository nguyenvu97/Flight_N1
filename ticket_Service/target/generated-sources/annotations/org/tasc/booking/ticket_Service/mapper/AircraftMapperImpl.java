package org.tasc.booking.ticket_Service.mapper;

import java.util.ArrayList;
import java.util.List;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;
import org.tasc.booking.ticket_Service.dto.AircraftDto;
import org.tasc.booking.ticket_Service.entity.Aircraft;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2024-11-12T10:30:51+0700",
    comments = "version: 1.5.5.Final, compiler: javac, environment: Java 20.0.1 (Oracle Corporation)"
)
@Component
public class AircraftMapperImpl implements AircraftMapper {

    @Override
    public Aircraft toDto(AircraftDto aircraftDto) {
        if ( aircraftDto == null ) {
            return null;
        }

        Aircraft.AircraftBuilder aircraft = Aircraft.builder();

        aircraft.id( aircraftDto.getId() );
        aircraft.type( aircraftDto.getType() );
        aircraft.code( aircraftDto.getCode() );
        aircraft.totalSeats( aircraftDto.getTotalSeats() );
        aircraft.economySeats( aircraftDto.getEconomySeats() );
        aircraft.businessSeats( aircraftDto.getBusinessSeats() );
        aircraft.pricePerKm( aircraftDto.getPricePerKm() );
        aircraft.status( aircraftDto.getStatus() );

        return aircraft.build();
    }

    @Override
    public AircraftDto toEntity(Aircraft aircraft) {
        if ( aircraft == null ) {
            return null;
        }

        AircraftDto aircraftDto = new AircraftDto();

        aircraftDto.setId( aircraft.getId() );
        aircraftDto.setType( aircraft.getType() );
        aircraftDto.setCode( aircraft.getCode() );
        aircraftDto.setTotalSeats( aircraft.getTotalSeats() );
        aircraftDto.setEconomySeats( aircraft.getEconomySeats() );
        aircraftDto.setBusinessSeats( aircraft.getBusinessSeats() );
        aircraftDto.setPricePerKm( aircraft.getPricePerKm() );
        aircraftDto.setStatus( aircraft.getStatus() );

        return aircraftDto;
    }

    @Override
    public List<Aircraft> toListEntity(List<AircraftDto> d) {
        if ( d == null ) {
            return null;
        }

        List<Aircraft> list = new ArrayList<Aircraft>( d.size() );
        for ( AircraftDto aircraftDto : d ) {
            list.add( toDto( aircraftDto ) );
        }

        return list;
    }

    @Override
    public List<AircraftDto> toListDto(List<Aircraft> e) {
        if ( e == null ) {
            return null;
        }

        List<AircraftDto> list = new ArrayList<AircraftDto>( e.size() );
        for ( Aircraft aircraft : e ) {
            list.add( toEntity( aircraft ) );
        }

        return list;
    }
}
