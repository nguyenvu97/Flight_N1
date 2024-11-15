package org.tasc.booking.ticket_Service.entity;


import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.Collection;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
@Table(name = "aircarf")
public class Aircraft {
    @Id
    @Column(name = "id")
    private int id;


    @Column(length = 50,name = "type")
    private String type;


    @Column(length = 250,name = "code")
    private String code;
    @Column(name = "total_seats") // sua lai // todo
    private int totalSeats;
    @Column(name = "economy_seats") // sua lai // todo
    private int economySeats;
    @Column(name = "businessseats")
    private int businessSeats;
    @Column(name = "price_per_km")
    private double pricePerKm;
    @Column(name = "status")
    private int status;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "airline_id", insertable = false, updatable = false)
    private Airline airline;

    @OneToMany(mappedBy = "aircraft")
    private Collection<Flight> flightSegments = new ArrayList<>();
}
