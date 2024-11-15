package org.tasc.booking.hotel_Service.service;

import org.tasc.booking.hotel_Service.dto.PageDto;
import org.tasc.booking.hotel_Service.dto.ReviewDto;
import org.tasc.booking.hotel_Service.projection.ReviewCount;

import java.util.Map;

public interface ReviewService {

    String createReview(ReviewDto review );

    PageDto getReviews(long hotelId, int pageNumber);

    ReviewCount startHotelId(long hotelId);
    Map<Integer, Integer> start_Sequentially(long hotelId);


    int start(long userId,long reviewId );
}
