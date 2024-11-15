package org.tasc.booking.hotel_Service.service.impl;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.tasc.booking.apiclient.ex.NotFound;
import org.tasc.booking.hotel_Service.dto.RoomDto;
import org.tasc.booking.hotel_Service.entity.Enum.CategoryType;
import org.tasc.booking.hotel_Service.entity.Enum.RoomStatus;
import org.tasc.booking.hotel_Service.entity.Hotel;
import org.tasc.booking.hotel_Service.entity.Room;
import org.tasc.booking.hotel_Service.mapper.RoomMapper;
import org.tasc.booking.hotel_Service.projection.RoomData;
import org.tasc.booking.hotel_Service.repository.HotelRepository;
import org.tasc.booking.hotel_Service.repository.RoomRepository;
import org.tasc.booking.hotel_Service.service.RoomService;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@RequiredArgsConstructor
@Service
@Transactional
public class RoomServiceImpl implements RoomService {
    private final RoomRepository roomRepository;
    private final HotelRepository hotelRepository;
    private final RoomMapper roomMapper;
    private  final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    @Async
    @Override
    public String add(List<Room> room,long hotelId) {
        List<Room> rooms = new ArrayList<>();
        if (hotelId > 0 && room.isEmpty()) {
            throw new NotFound("data not good");
        }
        Hotel hotel = hotelRepository.findById(hotelId).orElseThrow(()->  new NotFound("hotel not found"));
                for (Room room1 : room) {
                    room1.setHotel(hotel);
                    room1.setCategoryType(room1.getCategoryType());
                    room1.setRoomStatus(RoomStatus.Open);
                    rooms.add(room1);

                }
                roomRepository.saveAll(room);
                return "Ok";

    }

    @Override
    @Async
    public List<RoomDto> findByHotelId(Long hotelId) {
        List<Room> rooms = roomRepository.findByHotelIdAndStatus(hotelId,RoomStatus.Off);
        return roomMapper.toListDto(rooms);
    }


    @Override
    @Async
    public RoomData countRoomsByHotelId(Long hotelId, CategoryType categoryType, int numberPeople, int numberRoom, String startTime, String endTime)  {
        if (numberPeople <= 0 || numberRoom <= 0) {
            numberPeople = 2;
            numberRoom = 1;
        }
        System.out.println("Counting rooms with hotelId: " + hotelId + ", categoryType: " + categoryType + ", numberPeople: " + numberPeople + ", numberRoom: " + numberRoom + ", startTime: " + startTime + ", endTime: " + endTime);
        LocalDate startDate = LocalDate.parse(startTime);
        LocalDate endDate = LocalDate.parse(endTime);
        var roomData = roomRepository.countByHotelId(hotelId,categoryType,numberPeople,numberRoom,RoomStatus.Open,
                startDate,
                endDate );
            return roomData;





    }

}
