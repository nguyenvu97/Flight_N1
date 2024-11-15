package org.tasc.booking.ticket_Service.repository;

import org.tasc.booking.ticket_Service.entity.Route;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;


@Repository
public interface RouteRepository extends JpaRepository<Route, Integer> {
}
