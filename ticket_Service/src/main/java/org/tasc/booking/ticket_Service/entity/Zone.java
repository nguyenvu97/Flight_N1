package org.tasc.booking.ticket_Service.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.List;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Zone {
    @Id
    @Column(name = "id")
    private int id;
    @Column(name = "name")
    private String name;

    @OneToMany(mappedBy = "zone")
    private List<Airport> airports = new ArrayList<>();
}
