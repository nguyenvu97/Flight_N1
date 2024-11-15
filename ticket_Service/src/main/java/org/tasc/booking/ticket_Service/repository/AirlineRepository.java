package org.tasc.booking.ticket_Service.repository;

import org.tasc.booking.ticket_Service.entity.Airline;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AirlineRepository extends JpaRepository<Airline, Integer> {
}
