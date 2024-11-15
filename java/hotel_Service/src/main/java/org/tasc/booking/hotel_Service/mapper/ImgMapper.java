package org.tasc.booking.hotel_Service.mapper;

import org.mapstruct.Mapper;
import org.tasc.booking.apiclient.mapper.MapperAll;
import org.tasc.booking.apiclient.mapper.MapperConfig;
import org.tasc.booking.hotel_Service.dto.ImageDto;
import org.tasc.booking.hotel_Service.entity.Image;


import java.util.List;

@Mapper(config = MapperConfig.class)
public interface ImgMapper extends MapperAll<Image, ImageDto> {
    @Override
    Image toDto(ImageDto imageDto);

    @Override
    ImageDto toEntity(Image image);

    @Override
    List<Image> toListEntity(List<ImageDto> d);

    @Override
    List<ImageDto> toListDto(List<Image> e);
}
