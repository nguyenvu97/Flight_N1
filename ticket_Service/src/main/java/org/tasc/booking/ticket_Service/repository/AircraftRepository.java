package org.tasc.booking.ticket_Service.repository;

import org.tasc.booking.ticket_Service.entity.Aircraft;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AircraftRepository extends JpaRepository<Aircraft, Integer> {
}
