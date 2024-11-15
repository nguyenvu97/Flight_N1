package org.tasc.booking.ticket_Service.service.impl;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.tasc.booking.apiclient.dto.CustomerDto;
import org.tasc.booking.apiclient.dto.Ticket;
import org.tasc.booking.apiclient.ex.NotFound;
import org.tasc.booking.ticket_Service.dto.Requet.SearchFlight;
import org.tasc.booking.ticket_Service.dto.Response.DateAndMoney;
import org.tasc.booking.ticket_Service.dto.Response.FlightDto;
import org.tasc.booking.ticket_Service.dto.Response.FlightResponse;
import org.tasc.booking.ticket_Service.entity.Flight;
import org.tasc.booking.ticket_Service.mapper.FlightMapper;
import org.tasc.booking.ticket_Service.repository.FlightRepository;
import org.tasc.booking.ticket_Service.service.FlightService;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.text.ParseException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class FlightServiceImpl implements FlightService {
    private final FlightRepository flightRepository;
    private final FlightMapper flightMapper;
    private final MongoTemplate mongoTemplate;


    @Override
    public FlightDto getFlight(int flightId,List<Integer>id) {
        Flight flight = flightRepository.findById(flightId).orElse(null);
        if (id != null){
            switch (id.size()){
                case 1 :
                    return  flightMapper.toEntityWithNoFlights(flight,"");

                case 2 :
                    return  flightMapper.toEntity(flight);
            }
        }else {
            return  flightMapper.toEntity(flight);
        }

       return null;
    }


    @Override
    @Async
    public FlightResponse getData(SearchFlight searchFlight, int number) {
        if (number <= 0) {
            throw new NotFound("input number must be greater than 0");
        } else {
            switch (number) {
                case 1:
                    return FlightResponse.
                            builder()
                            .adultQuantity(searchFlight.adultQuantity)
                            .childQuantity(searchFlight.childQuantity)
                            .flight_go(getFlight(searchFlight.startDate, searchFlight.endDate, searchFlight.departure, searchFlight.arrival, searchFlight.adultQuantity, searchFlight.childQuantity))
                            .flight_back(null)
                            .build();
                case 2:
                    return  FlightResponse
                            .builder()
                            .adultQuantity(searchFlight.adultQuantity)
                            .childQuantity(searchFlight.childQuantity)
                            .flight_go(getFlight(searchFlight.startDate, searchFlight.endDate, searchFlight.departure, searchFlight.arrival, searchFlight.adultQuantity, searchFlight.childQuantity))
                            .flight_back(getFlight(searchFlight.endDate, "", searchFlight.arrival, searchFlight.departure, searchFlight.adultQuantity, searchFlight.childQuantity))
                            .build();

            }
        }
        return null;
    }

    @Async
    @Override
    public List<FlightDto> getFlight(String startDate, String endDate, String departure, String arrival, int adultQuantity, int childQuantity) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        List<FlightDto> additionalFlightResponses = new ArrayList<>();
        LocalDate startTime = LocalDate.parse(startDate, formatter);
        System.out.println(startTime.atStartOfDay());
        List<Flight> flights = flightRepository.countPreviousSegment(startTime.atStartOfDay(),arrival,departure);



        List<FlightDto> primaryFlight  = flights.stream().map(
                flight1 -> {

                    FlightDto flightDto =  flightMapper.toEntityWithNoFlights(flight1,null);
                    flightDto.setSeats(assets(flight1.getId()));
                    return  flightDto;
                }
        ).collect(Collectors.toList());
        additionalFlightResponses.addAll(primaryFlight);

        List<Flight> flights1 = flightRepository.findByStartTimeAndDeparture(startTime.atStartOfDay(),departure);


        List<FlightDto> secondaryFlight = flights1.stream().map(
                flight -> {

                    Flight nextFlight = flightRepository.findByArrivalAndStartDate(startTime.atStartOfDay(),arrival, flight.getId());
                    if (nextFlight == null) return null;
                    FlightDto flightDto =  flightMapper.toEntity(flight);


                    flightDto.setSeats(assets(flight.getId()));
                    Flight flight_child = flightRepository.findById(flightDto.getFlights().stream().findFirst().get().getId()).orElse(null);

                    flightDto.getFlights().stream().findFirst().get().setSeats(assets(flight_child.getId()));
                    flightDto.getFlights().stream().findFirst().get().setEconomySeats(flight_child.getAircraft().getEconomySeats());
                    flightDto.getFlights().stream().findFirst().get().setBusinessSeats(flight_child.getAircraft().getBusinessSeats());
                    flightDto.getFlights().stream().findFirst().get().setTotalSeats(flight_child.getAircraft().getTotalSeats());
                    flightDto.getFlights().stream().findFirst().get().setAirline(flight_child.getAircraft().getAirline().getName());
                    return  flightDto;

                }
        ).filter(Objects::nonNull) .collect(Collectors.toList());
        additionalFlightResponses.addAll(secondaryFlight);

        if(additionalFlightResponses.size() <= 0){
            throw  new NotFound("flight not found");
        }

        return additionalFlightResponses;
    }

    public Set<String> assets(int flightId) {
        Query query = new Query(new Criteria().orOperator(
                Criteria.where("OrderStatus").is("ok").and("customers.seats_go." + flightId).exists(true),
                Criteria.where("OrderStatus").is("ok").and("customers.seats_go_child." + flightId).exists(true),
                Criteria.where("OrderStatus").is("ok").and("customers.seats_back." + flightId).exists(true),
                Criteria.where("OrderStatus").is("ok").and("customers.seats_back_child." + flightId).exists(true)
        ));

        Set<String> data = new HashSet<>();
        List<Ticket> tickets = mongoTemplate.find(query, Ticket.class);

        for (Ticket ticket : tickets) {
            for (CustomerDto customer : ticket.getCustomers()) {

                    if (customer.getSeats_go().containsKey(flightId)) {
                        data.add(customer.getSeats_go().get(flightId));
                    }

                if (customer.getSeats_go_child().containsKey(flightId)) {
                    data.add(customer.getSeats_go_child().get(flightId));
                }


                if (customer.getSeats_back().containsKey(flightId)) {
                    data.add(customer.getSeats_back().get(flightId));
                }
                if (customer.getSeats_back_child().containsKey(flightId)) {
                    data.add(customer.getSeats_back_child().get(flightId));
                }
            }
        }
        return data;
    }
    public Set<String> assets_data(int flightId,String type_seats_go ) {
        Query query = null;
        if (type_seats_go.equals("Economy") ) {
            query = new Query(new Criteria().orOperator(
                    Criteria.where("ticketTypeGo").is(type_seats_go).and("OrderStatus").is("ok").and("customers.seats_go." + flightId).exists(true),
                    Criteria.where("ticketTypeGo").is(type_seats_go).and("OrderStatus").is("ok").and("customers.seats_go_child." + flightId).exists(true),
                    Criteria.where("ticketTypeGo").is(type_seats_go).and("OrderStatus").is("ok").and("customers.seats_back." + flightId).exists(true),
                    Criteria.where("ticketTypeGo").is(type_seats_go).and("OrderStatus").is("ok").and("customers.seats_back_child." + flightId).exists(true)
            ));
        }else {
                query = new Query(new Criteria().orOperator(
                        Criteria.where("ticketTypeBack").is(type_seats_go).and("OrderStatus").is("ok").and("customers.seats_go." + flightId).exists(true),
                        Criteria.where("ticketTypeBack").is(type_seats_go).and("OrderStatus").is("ok").and("customers.seats_go_child." + flightId).exists(true),
                        Criteria.where("ticketTypeBack").is(type_seats_go).and("OrderStatus").is("ok").and("customers.seats_back." + flightId).exists(true),
                        Criteria.where("ticketTypeBack").is(type_seats_go).and("OrderStatus").is("ok").and("customers.seats_back_child." + flightId).exists(true)
                ));

        }
        Set<String> data = new HashSet<>();
        List<Ticket> tickets = mongoTemplate.find(query, Ticket.class);

        for (Ticket ticket : tickets) {
            for (CustomerDto customer : ticket.getCustomers()) {

                if (customer.getSeats_go().containsKey(flightId)) {
                    data.add(customer.getSeats_go().get(flightId));
                }

                if (customer.getSeats_go_child().containsKey(flightId)) {
                    data.add(customer.getSeats_go_child().get(flightId));
                }


                if (customer.getSeats_back().containsKey(flightId)) {
                    data.add(customer.getSeats_back().get(flightId));
                }
                if (customer.getSeats_back_child().containsKey(flightId)) {
                    data.add(customer.getSeats_back_child().get(flightId));
                }
            }
        }
        return data;
    }

    @Override
    @Async
    public Set<String> assets(int flightId, String type_seats) {
        if(type_seats == null  ) {
            return  assets(flightId);
        }else {
            return assets_data(flightId,type_seats);
        }


    }

    @Override
    public List<DateAndMoney> getDateFlight(String startDate, String endDate, String departure, String arrival) throws ParseException {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy/MM/dd");

        List<DateAndMoney>dateAndMonies = new ArrayList<>();

        LocalDate givenDate = LocalDate.parse(startDate, formatter);

        List<String> dates = new ArrayList<>();


        for (int i = 7 ; i > 0 ; i --) {
            LocalDate previousDate = givenDate.minusDays(i);
            dates.add(previousDate.format(formatter));
        }
        dates.add(givenDate.format(formatter));
        for (int j = 1; j <= 7; j++) {
            LocalDate nextDate = givenDate.plusDays(j);
            dates.add(nextDate.format(formatter));
        }
        return dateAndMonies;
    }




}


