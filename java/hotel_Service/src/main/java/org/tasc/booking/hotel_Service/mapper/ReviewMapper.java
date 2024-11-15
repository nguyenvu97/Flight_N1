package org.tasc.booking.hotel_Service.mapper;

import org.mapstruct.Mapper;
import org.tasc.booking.apiclient.mapper.MapperAll;
import org.tasc.booking.apiclient.mapper.MapperConfig;
import org.tasc.booking.hotel_Service.dto.ReviewDto;
import org.tasc.booking.hotel_Service.entity.Review;

import java.util.List;

@Mapper(config = MapperConfig.class)
public interface ReviewMapper extends MapperAll<Review, ReviewDto> {
    @Override
//    @Mappings({
//
//    })
    Review toDto(ReviewDto reviewDto);

    @Override
    ReviewDto toEntity(Review review);

    @Override
    List<Review> toListEntity(List<ReviewDto> d);

    @Override
    List<ReviewDto> toListDto(List<Review> e);
}
