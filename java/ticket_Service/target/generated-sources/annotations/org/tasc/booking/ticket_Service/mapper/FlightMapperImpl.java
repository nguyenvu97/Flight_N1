package org.tasc.booking.ticket_Service.mapper;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;
import org.tasc.booking.ticket_Service.dto.Response.FlightDto;
import org.tasc.booking.ticket_Service.entity.Aircraft;
import org.tasc.booking.ticket_Service.entity.Airline;
import org.tasc.booking.ticket_Service.entity.Flight;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2024-11-12T10:30:51+0700",
    comments = "version: 1.5.5.Final, compiler: javac, environment: Java 20.0.1 (Oracle Corporation)"
)
@Component
public class FlightMapperImpl implements FlightMapper {

    @Override
    public Flight toDto(FlightDto flightResponse) {
        if ( flightResponse == null ) {
            return null;
        }

        Flight.FlightBuilder flight = Flight.builder();

        flight.id( flightResponse.getId() );
        flight.fromCity( flightResponse.getFromCity() );
        flight.toCity( flightResponse.getToCity() );
        flight.departureTime( flightResponse.getDepartureTime() );
        flight.arrivalTime( flightResponse.getArrivalTime() );
        flight.basePrice( flightResponse.getBasePrice() );
        flight.reservedSeats( flightResponse.getReservedSeats() );
        flight.reservedBusinessSeats( flightResponse.getReservedBusinessSeats() );
        flight.code( flightResponse.getCode() );

        return flight.build();
    }

    @Override
    public FlightDto toEntity(Flight flightSegment) {
        if ( flightSegment == null ) {
            return null;
        }

        FlightDto flightDto = new FlightDto();

        flightDto.setTotalSeats( flightSegmentAircraftTotalSeats( flightSegment ) );
        flightDto.setEconomySeats( flightSegmentAircraftEconomySeats( flightSegment ) );
        flightDto.setBusinessSeats( flightSegmentAircraftBusinessSeats( flightSegment ) );
        flightDto.setAirline( flightSegmentAircraftAirlineName( flightSegment ) );
        flightDto.setFlights( flightCollectionToFlightDtoList( flightSegment.getSubsequentSegments() ) );
        flightDto.setId( flightSegment.getId() );
        flightDto.setFromCity( flightSegment.getFromCity() );
        flightDto.setToCity( flightSegment.getToCity() );
        flightDto.setDepartureTime( flightSegment.getDepartureTime() );
        flightDto.setArrivalTime( flightSegment.getArrivalTime() );
        flightDto.setBasePrice( flightSegment.getBasePrice() );
        flightDto.setReservedSeats( flightSegment.getReservedSeats() );
        flightDto.setReservedBusinessSeats( flightSegment.getReservedBusinessSeats() );
        flightDto.setCode( flightSegment.getCode() );

        return flightDto;
    }

    @Override
    public FlightDto toEntityWithNoFlights(Flight flightSegment, String data) {
        if ( flightSegment == null && data == null ) {
            return null;
        }

        FlightDto flightDto = new FlightDto();

        if ( flightSegment != null ) {
            flightDto.setTotalSeats( flightSegmentAircraftTotalSeats( flightSegment ) );
            flightDto.setEconomySeats( flightSegmentAircraftEconomySeats( flightSegment ) );
            flightDto.setBusinessSeats( flightSegmentAircraftBusinessSeats( flightSegment ) );
            flightDto.setAirline( flightSegmentAircraftAirlineName( flightSegment ) );
            flightDto.setId( flightSegment.getId() );
            flightDto.setFromCity( flightSegment.getFromCity() );
            flightDto.setToCity( flightSegment.getToCity() );
            flightDto.setDepartureTime( flightSegment.getDepartureTime() );
            flightDto.setArrivalTime( flightSegment.getArrivalTime() );
            flightDto.setBasePrice( flightSegment.getBasePrice() );
            flightDto.setReservedSeats( flightSegment.getReservedSeats() );
            flightDto.setReservedBusinessSeats( flightSegment.getReservedBusinessSeats() );
            flightDto.setCode( flightSegment.getCode() );
        }
        flightDto.setFlights( null );

        return flightDto;
    }

    @Override
    public List<Flight> toListEntity(List<FlightDto> d) {
        if ( d == null ) {
            return null;
        }

        List<Flight> list = new ArrayList<Flight>( d.size() );
        for ( FlightDto flightDto : d ) {
            list.add( toDto( flightDto ) );
        }

        return list;
    }

    @Override
    public List<FlightDto> toListDto(List<Flight> e) {
        if ( e == null ) {
            return null;
        }

        List<FlightDto> list = new ArrayList<FlightDto>( e.size() );
        for ( Flight flight : e ) {
            list.add( toEntity( flight ) );
        }

        return list;
    }

    private int flightSegmentAircraftTotalSeats(Flight flight) {
        if ( flight == null ) {
            return 0;
        }
        Aircraft aircraft = flight.getAircraft();
        if ( aircraft == null ) {
            return 0;
        }
        int totalSeats = aircraft.getTotalSeats();
        return totalSeats;
    }

    private int flightSegmentAircraftEconomySeats(Flight flight) {
        if ( flight == null ) {
            return 0;
        }
        Aircraft aircraft = flight.getAircraft();
        if ( aircraft == null ) {
            return 0;
        }
        int economySeats = aircraft.getEconomySeats();
        return economySeats;
    }

    private int flightSegmentAircraftBusinessSeats(Flight flight) {
        if ( flight == null ) {
            return 0;
        }
        Aircraft aircraft = flight.getAircraft();
        if ( aircraft == null ) {
            return 0;
        }
        int businessSeats = aircraft.getBusinessSeats();
        return businessSeats;
    }

    private String flightSegmentAircraftAirlineName(Flight flight) {
        if ( flight == null ) {
            return null;
        }
        Aircraft aircraft = flight.getAircraft();
        if ( aircraft == null ) {
            return null;
        }
        Airline airline = aircraft.getAirline();
        if ( airline == null ) {
            return null;
        }
        String name = airline.getName();
        if ( name == null ) {
            return null;
        }
        return name;
    }

    protected List<FlightDto> flightCollectionToFlightDtoList(Collection<Flight> collection) {
        if ( collection == null ) {
            return null;
        }

        List<FlightDto> list = new ArrayList<FlightDto>( collection.size() );
        for ( Flight flight : collection ) {
            list.add( toEntity( flight ) );
        }

        return list;
    }
}
