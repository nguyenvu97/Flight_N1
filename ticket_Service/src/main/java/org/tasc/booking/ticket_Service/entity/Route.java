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
@Table(name = "routes")
public class Route {
    @Id
    @Column(name = "id")
    private int id;
    @Column(name = "distance")
    private int distance;
    @Column(name = "status")
    private int status;
    @Column(name = "search")
    private String search;
    @Column(name = "note")
    private String note;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "de_a_id", insertable = false, updatable = false)
    private Airport departurePort;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ar_a_id", insertable = false, updatable = false)
    private Airport arrivalPort;

    @OneToMany(mappedBy = "route")
    private Collection<Flight> flightSegments = new ArrayList<>();
}
