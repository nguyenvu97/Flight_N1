package org.tasc.booking.hotel_Service.service.impl;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.tasc.booking.hotel_Service.entity.Hotel;
import org.tasc.booking.hotel_Service.entity.Image;
import org.tasc.booking.hotel_Service.repository.ImageRepository;
import org.tasc.booking.hotel_Service.service.ImageService;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class ImageServiceImpl implements ImageService {
    private final ImageRepository imageRepository;
    @Value("${uploading.videoSaveFolder}")
    private String FOLDER_PATH;


    @Override
    @Async
    public void add(List<MultipartFile> fileList, Hotel hotel) throws IOException {
        if (fileList != null && !fileList.isEmpty()) {
            List<Image> images = new ArrayList<>();

            for (MultipartFile file : fileList) {
                String randomImageName = LocalDateTime.now().toString();
                String pathImg = FOLDER_PATH + "/" + randomImageName;
                file.transferTo(new File(pathImg));
                Image image = new Image();
                image.setImg(randomImageName);
                image.setPathImg(pathImg);
                image.setHotel(hotel);
                images.add(image);
            }

        }
    }

    @Async
    @Override
    public byte[] uploadFilesImage(String fileName) throws IOException {
        if (fileName == null || fileName.isEmpty()) {
            throw new RuntimeException("File name is empty or null");
        }
        Image image =  imageRepository.findByImg(fileName);
        if (image == null) {
            throw new RuntimeException("Image not found for file name: " + fileName);
        }
        String pathImage = image.getPathImg();
        File file = new File(pathImage);

        if (!file.exists()) {
            throw new RuntimeException("File not found at path: " + pathImage);
        }

        return Files.readAllBytes(file.toPath());
    }
}
