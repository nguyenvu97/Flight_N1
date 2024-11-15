package org.tasc.booking.ticket_Service.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.Collection;

@Table(name ="airline")
@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
public class Airline {

    @Id
    private int id;
    @Column(name = "name")
    private String name;
    @Column(name = "code",insertable=false, updatable=false)
    private String code;
    @Column(name = "code")
    private String note;

    @OneToMany(mappedBy = "airline")
    private Collection<Aircraft> aircrafts = new ArrayList<>();
}
