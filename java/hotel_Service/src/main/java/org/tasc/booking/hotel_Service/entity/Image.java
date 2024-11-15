package org.tasc.booking.hotel_Service.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Entity
public class Image {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    public String img;
    private String pathImg;
    @ManyToOne
    @JoinColumn(name = "hotel_id")
    public Hotel hotel;
}
