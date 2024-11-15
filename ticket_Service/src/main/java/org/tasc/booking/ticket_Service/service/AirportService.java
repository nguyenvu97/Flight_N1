package org.tasc.booking.ticket_Service.service;

import org.tasc.booking.ticket_Service.dto.AirportDto;

import java.util.List;
import java.util.Map;

public interface AirportService {
    Map<String, List<AirportDto>>  getLocal();
}
