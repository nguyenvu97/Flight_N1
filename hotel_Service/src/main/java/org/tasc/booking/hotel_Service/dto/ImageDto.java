package org.tasc.booking.hotel_Service.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ImageDto {
    private long id;
    public String img;
    private String pathImg;
}
