package org.tasc.booking.ticket_Service.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collection;


@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Table(name = "flight_segment")
@Entity
public class Flight {
    @Id
    @Column(name = "id")
    private int id;
    @Column(name = "from_city") // sua lai // todo
    private String fromCity;
    @Column(name = "to_city") // sua lai // todo
    private String toCity;
    @Column(name = "de_time")
    private LocalDateTime departureTime;
    @Column(name = "ar_time")
    private LocalDateTime arrivalTime;
    @Column(name = "base_price" )
    private BigDecimal basePrice;
    @Column(name = "r_eseats")
    private int reservedSeats;
    @Column(name ="r_bseats" )
    private int reservedBusinessSeats;
    @Column(name = "status")
    private int status;
    @Column(name = "code")
    private String code;
    @Column(name = "note" )
    private String note;
//    @Column(name = "order")
//    private int order;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "previous_segment_id", insertable = false, updatable = false)
    private Flight previousSegment;

    @OneToMany(mappedBy = "previousSegment")
    private Collection<Flight> subsequentSegments = new ArrayList<>();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "air_id", insertable = false, updatable = false)
    private Aircraft aircraft;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "route_id", insertable = false, updatable = false)
    private Route route;

}
