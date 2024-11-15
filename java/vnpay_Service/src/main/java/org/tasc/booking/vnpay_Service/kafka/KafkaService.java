package org.tasc.booking.vnpay_Service.kafka;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.tasc.booking.apiclient.dto.Ticket;

import static org.tasc.booking.vnpay_Service.kafka.DateTimeUtils.convertDateTimeToString;
import static org.tasc.booking.vnpay_Service.kafka.DateTimeUtils.convertStringToDateTime;


@Service
@Slf4j
@RequiredArgsConstructor
public class KafkaService {
    private final KafkaTemplate<String, String> kafkaTemplate;
    private String topic = "sys_ticket_booking";

    @Async
    public void send_ticket(Ticket ticketDto) {
        try{
            if (ticketDto != null) {
                // Kiểm tra và chuyển đổi dữ liệu cho flights_back nếu có
                if (ticketDto.getFlights_back() != null) {
                    if (ticketDto.getFlights_back().getDepartureTime() != null) {
                        // Chuyển mảng ngày giờ thành chuỗi và chuyển đổi lại thành LocalDateTime nếu cần
                        ticketDto.getFlights_back().setDepartureTime(convertStringToDateTime(convertDateTimeToString(ticketDto.getFlights_back().getDepartureTime())));
                    }
                    ticketDto.getFlights_back().setCode(ticketDto.getFlights_back().getCode());

                    if (ticketDto.getFlights_back().getArrivalTime() != null) {
                        ticketDto.getFlights_back().setArrivalTime(convertStringToDateTime(convertDateTimeToString(ticketDto.getFlights_back().getArrivalTime())));
                    }
                    ticketDto.getFlights_back().setCode(ticketDto.getFlights_back().getCode());
                }

                // Kiểm tra và chuyển đổi dữ liệu cho flights_go nếu có
                if (ticketDto.getFlights_go() != null) {
                    if (ticketDto.getFlights_go().getDepartureTime() != null) {
                        // Chuyển mảng ngày giờ thành chuỗi và chuyển đổi lại thành LocalDateTime nếu cần
                        ticketDto.getFlights_go().setDepartureTime(convertStringToDateTime(convertDateTimeToString(ticketDto.getFlights_go().getDepartureTime())));
                    }
                    ticketDto.getFlights_go().setCode(ticketDto.getFlights_go().getCode());

                    if (ticketDto.getFlights_go().getArrivalTime() != null) {
                        ticketDto.getFlights_go().setArrivalTime(convertStringToDateTime(convertDateTimeToString(ticketDto.getFlights_go().getArrivalTime())));
                    }
                    ticketDto.getFlights_go().setCode(ticketDto.getFlights_go().getCode());
                }
            }
            String ticketAsString = convertTicketToString(ticketDto);
            kafkaTemplate.send(topic, ticketAsString);
        }catch (Exception e){
            e.printStackTrace();
        }

    }


    public String convertTicketToString(Ticket ticket) {
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.registerModule(new JavaTimeModule());
            objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
            return objectMapper.writeValueAsString(ticket);
        } catch (JsonProcessingException e) {
            log.error("Error converting Ticket to String", e);
        }
        return null;
    }
}
