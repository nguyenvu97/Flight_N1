package org.tasc.booking.ticket_Service.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.tasc.booking.apiclient.dto.CustomerDto;
import org.tasc.booking.apiclient.dto.FlightTickitDto;
import org.tasc.booking.ticket_Service.dto.Requet.OrderDto;
import org.tasc.booking.apiclient.dto.Ticket;
import org.tasc.booking.ticket_Service.mapper.FlightOrder;
import org.tasc.booking.ticket_Service.service.FlightService;
import org.tasc.booking.ticket_Service.service.TicketService;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class TicketServiceImpl implements TicketService {
    private final FlightService flightService;
    private final MongoTemplate mongoTemplate;
    private final FlightOrder flightOrder;
    private static double Business_Money = 2;
    private static double Economy_Money = 1.5;
    private static double child_discount = 0.25;
    private static double badge_money = 500000;

    /*
    *
    * ticketTypeGo == true co nghi ve 1 chieu
    * */


    public String orderNo() {
        Random random = new Random();
        return "orderNo" + random.nextInt(1000000);
    }

    @Override
    @Async

    public Ticket createTicket(OrderDto ticket) {
        FlightTickitDto flightGo = new FlightTickitDto() ;
        FlightTickitDto flightBack = new FlightTickitDto();


         flightGo = ticket.flight_go.stream().map(flight -> {
            return flightOrder.toEntity(flightService.getFlight(flight, ticket.getFlight_go()));
        }).findFirst().get();
        String orderNo = orderNo();

        if (ticket.getFlight_back() != null && !ticket.getFlight_back().isEmpty()) {

             flightBack = ticket.flight_back.stream().map(flight -> {
                return flightOrder.toEntity(flightService.getFlight(flight, ticket.getFlight_go()));
            }).findFirst().get();
            }
        if (ticket.getFlight_back() == null || ticket.getFlight_back().isEmpty() ) {
            math_money_for_customer(ticket.customers,flightGo,null,ticket.ticketTypeGo, null);
        }else {
            math_money_for_customer(ticket.customers,flightGo,flightBack,ticket.ticketTypeGo,ticket.ticketTypeBack);
        }


            if (ticket.getFlight_back() == null || ticket.getFlight_back().isEmpty()) {
                return addTicket(ticket.customers, flightGo, null, ticket.ticketTypeGo, null,orderNo);
            } else {

                return addTicket(ticket.customers, flightGo, flightBack, ticket.ticketTypeGo, ticket.ticketTypeBack,orderNo);
            }
    }

    @Async
    public Ticket addTicket(List<CustomerDto> customerDtos, FlightTickitDto flights_go, FlightTickitDto flights_back, boolean ticketTypeGo, Boolean ticketTypeBack,String orderNo) {
        double totalMoney = customerDtos.stream()
                .mapToDouble(customerDto -> {
                    return customerDto.getAmountTotal();
                })
                .sum();
        return mongoTemplate.insert(Ticket
                .builder()
                .flights_go(flights_go)
                .flights_back(flights_back)
                .OrderStatus("pending")
                .orderNo(orderNo)
                .customers(customerDtos)
                .flights_go(flights_go)
                .flights_back(flights_back)
                .ticketTypeGo(ticketTypeGo ? "Economy" : "Business")
                .ticketTypeBack( ticketTypeBack!= null ? ticketTypeBack ? "Economy" : "Business" : null )
                .ticketType(flights_back == null ? "OneWay" : "RouterTrip")
                .totalTicket(totalMoney)
                .build()
        );


    }



    public List<Ticket> getAll() {
        return mongoTemplate.findAll(Ticket.class);
    }

    @Override
    public Ticket getOrderNo(String orderNo) {
        Query query = new Query(new Criteria("orderNo").is(orderNo));
        return mongoTemplate.find(query, Ticket.class).stream().findFirst().orElse(null);
    }

    @Override
    public void update(String orderNo) {
       Ticket tickets = getOrderNo(orderNo);
        tickets.setOrderStatus("ok");
        mongoTemplate.save(tickets);
    }

    private void math_money_for_customer(List<CustomerDto>customerDtos , FlightTickitDto flights_go, FlightTickitDto flights_back,boolean ticketTypeGo,Boolean ticketTypeBack){
        var amount_go = 0.0;
        var amount_back = 0.0;


        log.info(flights_go.toString());

        if (flights_go != null) {
            if (flights_go.getFlights() != null){
                amount_go = flights_go.getBasePrice().doubleValue() + flights_go.getFlights().get(0).getBasePrice().doubleValue();
            }else {
                amount_go = flights_go.getBasePrice().doubleValue();
            }
        }

       if (flights_back != null) {
           if (flights_back.getFlights() != null){
               amount_back = flights_back.getBasePrice().doubleValue() + flights_back.getFlights().get(0).getBasePrice().doubleValue();
           }else {
               amount_back = flights_back.getBasePrice().doubleValue();
           }
       }
        if (ticketTypeGo){
            amount_go = amount_go * Economy_Money;
        }else {
            amount_go = amount_go * Business_Money;
        }
        if (ticketTypeBack != null){
            if (ticketTypeBack){
                amount_back = amount_back * Economy_Money;
            }else {
                amount_go = amount_go * Business_Money;
            }
        }


        var totalMoney = amount_go + amount_back;

        for (CustomerDto customerDto : customerDtos) {
            if (customerDto.getCustomType().equals("child")){
                customerDto.setAmountTotal(totalMoney * (1 -child_discount) + ((customerDto.getBag_go() * badge_money) + (customerDto.getBag_back() * badge_money)) );
            }else {
                customerDto.setAmountTotal(totalMoney + ((customerDto.getBag_go() * badge_money) + (customerDto.getBag_back() * badge_money)));
            }
        }
    }
}



