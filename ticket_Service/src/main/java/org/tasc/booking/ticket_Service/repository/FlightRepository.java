package org.tasc.booking.ticket_Service.repository;

import org.tasc.booking.ticket_Service.entity.Flight;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface FlightRepository extends JpaRepository<Flight, Integer> {

    @Query("select f from Flight as f where  f.fromCity = :departure and DATE(f.departureTime) = DATE(:startDate)")
    List<Flight> findByStartTimeAndDeparture(@Param(value = "startDate") LocalDateTime startDate, @Param(value = "departure") String departure);

    @Query("select f from Flight as f where  f.toCity = :arrival and DATE(f.departureTime) >= DATE(:startDate) and  f.previousSegment.id = :id ")
    Flight  findByArrivalAndStartDate(@Param(value = "startDate") LocalDateTime startDate,@Param(value = "arrival")String arrival,@Param(value = "id")int flight);


    @Query("select f from Flight as f where f.toCity = :arrival and f.fromCity = :departure and DATE(f.departureTime) = DATE(:startDate)")
    List<Flight> countPreviousSegment(@Param(value = "startDate") LocalDateTime startDate,@Param(value = "arrival")String arrival,@Param(value = "departure")String departure);
    @Query("select f from Flight as f where DATE(f.departureTime) >= DATE(:startDate) and DATE(f.departureTime) < DATE(:startDate ) + 1  and f.toCity = :arrival and f.fromCity = :departure")
    Flight  findByArrivalAndStartDate(@Param(value = "startDate") LocalDateTime startDate,@Param(value = "arrival")String arrival,@Param(value = "departure")String departure);




}
