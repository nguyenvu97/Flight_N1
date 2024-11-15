//package org.springframework.boot.hotel.service.impl;
//
//import com.cloudinary.Cloudinary;
//import com.cloudinary.utils.ObjectUtils;
//import lombok.AllArgsConstructor;
//import lombok.RequiredArgsConstructor;
//import org.springframework.scheduling.annotation.Async;
//import org.springframework.stereotype.Service;
//import org.springframework.web.multipart.MultipartFile;
//
//import java.io.File;
//import java.io.IOException;
//import java.util.ArrayList;
//import java.util.List;
//import java.util.Map;
//
//@RequiredArgsConstructor
//@Service
//public class UploadService {
//
//    private final Cloudinary cloudinary;
//
//
//    @Async
//    public void upload(List<MultipartFile> images) throws IOException {
//        List<Map<String, Object>> uploadResults = new ArrayList<>();
//
//        for (MultipartFile image : images) {
//            Map<String, Object> params = ObjectUtils.asMap(
//                    "folder", "product",
//                    "use_filename", true,
//                    "unique_filename", false,
//                    "overwrite", true
//            );
//
//            // Convert MultipartFile to File
//            File file = convertMultipartFileToFile(image);
//
//            try {
//                // Upload the file and collect the result
//                Map<String, Object> uploadResult = cloudinary.uploader().upload(file, params);
//                uploadResults.add(uploadResult);
//            } catch (IOException e) {
//                // Handle the exception according to your requirements
//                throw new IOException("Error uploading file: " + image.getOriginalFilename(), e);
//            } finally {
//                // Cleanup file after upload
//                file.delete();
//            }
//        }
//        System.out.println(uploadResults);
//    }
//
//    private File convertMultipartFileToFile(MultipartFile multipartFile) throws IOException {
//        File file = new File(System.getProperty("java.io.tmpdir") + "/" + multipartFile.getOriginalFilename());
//        multipartFile.transferTo(file);
//        return file;
//    }
//
//}
