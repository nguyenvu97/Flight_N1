package org.tasc.booking.hotel_Service.service;

import org.tasc.booking.hotel_Service.entity.Hotel;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

public interface ImageService {
    void add(List<MultipartFile> fileList, Hotel hotel)throws IOException;
    byte[] uploadFilesImage(String fileName) throws IOException;
}
