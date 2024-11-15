package org.tasc.booking.hotel_Service.controller;

import lombok.RequiredArgsConstructor;
import org.tasc.booking.apiclient.ex.NotFound;
import org.tasc.booking.hotel_Service.entity.Room;
import org.tasc.booking.hotel_Service.repository.RoomRepository;
import org.tasc.booking.hotel_Service.service.RoomService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("api/v1/room")
public class RoomController {
    private final RoomService roomService;
    private final RoomRepository roomRepository;

    @PostMapping("/add")
    public ResponseEntity<?>add(@RequestBody List<Room> rooms,@RequestParam int hotelId) {
        try{
            return ResponseEntity.ok(roomService.add(rooms,hotelId));
        }catch (NotFound e){
            return  ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getData());
        }
    }

}
