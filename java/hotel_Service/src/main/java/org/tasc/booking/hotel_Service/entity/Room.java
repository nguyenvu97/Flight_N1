package org.tasc.booking.hotel_Service.entity;

import jakarta.persistence.*;
import lombok.*;
import org.tasc.booking.hotel_Service.entity.Enum.CategoryType;
import org.tasc.booking.hotel_Service.entity.Enum.RoomStatus;

import java.time.LocalDate;

@Setter
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
public class Room {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;
    private double price;
    private int numberPeople;
    private int numberRoom;
    @Column(name = "start_time")
    private LocalDate startTime;

    @Column(name = "end_time")
    private LocalDate endTime;
    private int quantityRoom;
    @Enumerated(EnumType.STRING)
    private CategoryType categoryType;
    @Enumerated(EnumType.STRING)
    private RoomStatus roomStatus;
    @ManyToOne
    @JoinColumn(name = "hotel_id")
    private Hotel hotel;

}
