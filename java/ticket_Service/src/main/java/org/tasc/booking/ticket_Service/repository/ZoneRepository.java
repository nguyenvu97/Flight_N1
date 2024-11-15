package org.tasc.booking.ticket_Service.repository;

import org.tasc.booking.ticket_Service.entity.Zone;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository

public interface ZoneRepository extends JpaRepository<Zone,Integer> {
}
