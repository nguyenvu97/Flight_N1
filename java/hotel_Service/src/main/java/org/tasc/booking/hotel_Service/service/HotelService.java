package org.tasc.booking.hotel_Service.service;

import org.tasc.booking.hotel_Service.dto.HotelDto;
import org.tasc.booking.hotel_Service.dto.ImageDto;
import org.tasc.booking.hotel_Service.dto.PageDto;
import org.tasc.booking.hotel_Service.dto.request.HotelSearch;
import org.tasc.booking.hotel_Service.entity.Hotel;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

public interface HotelService {
    String addHotel(Hotel hotel, List<MultipartFile> images) throws IOException;

    HotelDto findByID(long id);


    byte[] listImage(String imageName) throws IOException;



    List<ImageDto>findImages(Long hotelId);

    PageDto searchHotel(HotelSearch hotelSearch,int sortId);



}
