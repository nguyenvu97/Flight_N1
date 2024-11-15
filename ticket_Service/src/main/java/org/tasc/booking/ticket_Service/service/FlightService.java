package org.tasc.booking.ticket_Service.service;

import org.tasc.booking.ticket_Service.dto.Requet.SearchFlight;
import org.tasc.booking.ticket_Service.dto.Response.DateAndMoney;
import org.tasc.booking.ticket_Service.dto.Response.FlightDto;
import org.tasc.booking.ticket_Service.dto.Response.FlightResponse;


import java.text.ParseException;
import java.util.List;
import java.util.Set;

public interface FlightService {
    FlightDto getFlight(int flightId,List<Integer>id);


    FlightResponse getData(SearchFlight searchFlight, int number);

    List<FlightDto> getFlight(String startDate, String endDat, String departure, String arrival, int adultQuantity, int childQuantity);
    List<DateAndMoney>getDateFlight(String startDate, String endDate, String departure, String arrival) throws ParseException;
     Set<String> assets(int flightId,String type_seats);
}
