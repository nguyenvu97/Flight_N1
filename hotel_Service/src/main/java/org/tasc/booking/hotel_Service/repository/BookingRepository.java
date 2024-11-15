package org.tasc.booking.hotel_Service.repository;

import org.tasc.booking.hotel_Service.dto.BookingDto;
import org.tasc.booking.hotel_Service.entity.Booking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookingRepository extends JpaRepository<Booking, Long> {
    List<BookingDto> findByOrderNo(String orderNo);
}
