package org.tasc.booking.hotel_Service.mapper;

import java.util.ArrayList;
import java.util.List;
import javax.annotation.processing.Generated;
import org.springframework.stereotype.Component;
import org.tasc.booking.hotel_Service.dto.ReviewDto;
import org.tasc.booking.hotel_Service.entity.Review;

@Generated(
    value = "org.mapstruct.ap.MappingProcessor",
    date = "2024-11-12T10:30:53+0700",
    comments = "version: 1.5.5.Final, compiler: javac, environment: Java 20.0.1 (Oracle Corporation)"
)
@Component
public class ReviewMapperImpl implements ReviewMapper {

    @Override
    public Review toDto(ReviewDto reviewDto) {
        if ( reviewDto == null ) {
            return null;
        }

        Review.ReviewBuilder review = Review.builder();

        review.id( reviewDto.getId() );
        review.email( reviewDto.getEmail() );
        review.comment( reviewDto.getComment() );
        review.rating( reviewDto.getRating() );
        review.time( reviewDto.getTime() );

        return review.build();
    }

    @Override
    public ReviewDto toEntity(Review review) {
        if ( review == null ) {
            return null;
        }

        ReviewDto reviewDto = new ReviewDto();

        reviewDto.setId( review.getId() );
        reviewDto.setEmail( review.getEmail() );
        reviewDto.setComment( review.getComment() );
        reviewDto.setRating( (int) review.getRating() );
        reviewDto.setTime( review.getTime() );

        return reviewDto;
    }

    @Override
    public List<Review> toListEntity(List<ReviewDto> d) {
        if ( d == null ) {
            return null;
        }

        List<Review> list = new ArrayList<Review>( d.size() );
        for ( ReviewDto reviewDto : d ) {
            list.add( toDto( reviewDto ) );
        }

        return list;
    }

    @Override
    public List<ReviewDto> toListDto(List<Review> e) {
        if ( e == null ) {
            return null;
        }

        List<ReviewDto> list = new ArrayList<ReviewDto>( e.size() );
        for ( Review review : e ) {
            list.add( toEntity( review ) );
        }

        return list;
    }
}
