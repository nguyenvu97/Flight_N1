package org.tasc.booking.hotel_Service.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.tasc.booking.apiclient.ex.NotFound;
import org.tasc.booking.hotel_Service.dto.request.HotelSearch;
import org.tasc.booking.hotel_Service.entity.Hotel;
import org.tasc.booking.hotel_Service.service.HotelService;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("api/v1/hotel")
public class HotelController {
    private final HotelService hotelService;
    @PostMapping("/add")
    public ResponseEntity<?> add (@RequestParam("hotel") String hotel,
                                  @RequestParam(required = false,value = "image") List<MultipartFile> files
//                                  @RequestHeader("Authorization") String token
                                  ) throws IOException {
        ObjectMapper objectMapper = new ObjectMapper();
        Hotel hotel1 = objectMapper.readValue(hotel, Hotel.class);
      return ResponseEntity.ok(hotelService.addHotel(hotel1,files));
    }

    @GetMapping("findById")
    public ResponseEntity<?> findById (@RequestParam("hotelId") long hotelId) throws IOException {
        try{
            return ResponseEntity.ok(hotelService.findByID(hotelId));
        }catch (NotFound e){
            ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getData());
        }
        return  ResponseEntity.status(500).build();

    }
    @GetMapping("upload")
    public ResponseEntity<byte[]> getImage(@RequestParam String imgName) {
        try {
            byte[] imageBytes = hotelService.listImage(imgName);

            if (imageBytes != null) {
                return ResponseEntity.ok()
                        .contentType(MediaType.IMAGE_JPEG) // Đảm bảo định dạng chính xác
                        .body(imageBytes);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (IOException e) {
            return ResponseEntity.status(500).build();
        }
    }

    @PostMapping("/search")
    public ResponseEntity<?>search(@RequestBody HotelSearch hotelSearch , @RequestParam int sortId){
        try{
            return ResponseEntity.ok().body(hotelService.searchHotel(hotelSearch,sortId));
        }catch (NotFound e){
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getData());
        }

    }



}
