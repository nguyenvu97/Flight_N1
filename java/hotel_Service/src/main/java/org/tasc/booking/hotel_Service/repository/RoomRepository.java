package org.tasc.booking.hotel_Service.repository;

import org.tasc.booking.hotel_Service.entity.Enum.CategoryType;
import org.tasc.booking.hotel_Service.entity.Enum.RoomStatus;
import org.tasc.booking.hotel_Service.entity.Room;
import org.tasc.booking.hotel_Service.projection.RoomData;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface RoomRepository extends JpaRepository<Room, Long>, JpaSpecificationExecutor<Room> {

    @Query("select r from Room as r where r.hotel.id =:hotelId and r.roomStatus =:roomStatus ")
   List<Room>  findByHotelIdAndStatus(@Param("hotelId") Long hotelId,@Param("roomStatus") RoomStatus roomStatus);

    @Query("SELECT r.id as roomId , r.quantityRoom as countRoom , r.price as roomPrice , r.categoryType as categoryType  FROM Room r " +
            "WHERE r.hotel.id = :hotelId " +
            "AND r.categoryType = :categoryType " +
            "AND r.numberPeople = :numberPeople " +
            "AND r.numberRoom = :numberRoom " +
            "AND r.roomStatus = :roomStatus " +
            "AND r.startTime <= :startTime " +
            "And r.endTime >= :endTime"
    )
    RoomData countByHotelId(@Param("hotelId") Long hotelId,
                            @Param("categoryType") CategoryType categoryType,
                            @Param("numberPeople") int numberPeople,
                            @Param("numberRoom") int numberRoom,
                            @Param("roomStatus") RoomStatus roomStatus,
                            @Param("startTime") LocalDate startTime,
                            @Param("endTime") LocalDate endTime
                            );
}
