package org.tasc.booking.hotel_Service.config;

import lombok.Data;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Data
@Configuration
public class ConfigMap {
    @Value("${appConfig.default-page-size}")
    public  int pageSize;
    @Value("${appConfig.default-page-number}")
    public  int pageNumber;
    @Value("${appConfig.default-numberPeople}")
    private int numberPeople;
    @Value("${appConfig.default-numberRoom}")
    private int numberRoom;
//    public final String APIKEY= "655111386821477";
//    public final String APISECRET= "Zs2Zcw-7Pf3B6EWRiUUkV1tRYWA";
//    public final  String CLOUD_NAME= "dlqv9yphm";
//
//    @Bean
//    public Cloudinary config(){
//        Cloudinary cloudinary = new Cloudinary("cloudinary://"+APIKEY+":"+APISECRET+"@"+CLOUD_NAME);
//        cloudinary.config.secure = true;
//        return cloudinary;
//    }
}
