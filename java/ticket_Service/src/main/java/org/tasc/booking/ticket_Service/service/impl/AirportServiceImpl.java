package org.tasc.booking.ticket_Service.service.impl;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

import org.tasc.booking.ticket_Service.dto.AirportDto;

import org.tasc.booking.ticket_Service.entity.Airport;
import org.tasc.booking.ticket_Service.entity.Zone;
import org.tasc.booking.ticket_Service.mapper.AirportMapper;
import org.tasc.booking.ticket_Service.repository.AirportRepository;
import org.tasc.booking.ticket_Service.repository.ZoneRepository;
import org.tasc.booking.ticket_Service.service.AirportService;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class AirportServiceImpl implements AirportService {
    private final AirportRepository airportRepository;
    private final AirportMapper airPortMapper;
    private final ZoneRepository zoneRepository;



    @Override
    public Map<String, List<AirportDto>> getLocal() {
        Map<String, List<AirportDto>>  local = new HashMap<>();
        List<Zone> listzone = zoneRepository.findAll();
        for (Zone zone : listzone) {
            List<Airport>data = airportRepository.findByAriport(zone.getId());

           List<AirportDto> name = data.stream().map(ariport ->{
               return  airPortMapper.toEntity(ariport);
           }).collect(Collectors.toList());

            local.put(zone.getName(),name);
        }
        return local;





    }
}
