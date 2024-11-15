package org.tasc.booking.hotel_Service.service.impl;

import lombok.RequiredArgsConstructor;
import org.tasc.booking.apiclient.ex.NotFound;
import org.tasc.booking.hotel_Service.config.ConfigMap;
import org.tasc.booking.hotel_Service.dto.PageDto;
import org.tasc.booking.hotel_Service.dto.ReviewDto;
import org.tasc.booking.hotel_Service.entity.Hotel;
import org.tasc.booking.hotel_Service.entity.Review;
import org.tasc.booking.hotel_Service.mapper.ReviewMapper;
import org.tasc.booking.hotel_Service.projection.ReviewCount;
import org.tasc.booking.hotel_Service.repository.HotelRepository;
import org.tasc.booking.hotel_Service.repository.ReviewRepository;
import org.tasc.booking.hotel_Service.service.ReviewService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ReviewServiceImpl implements ReviewService {
    private final ReviewRepository reviewRepository;
    private final HotelRepository hotelRepository;
    private final ConfigMap configMap;
    private final ReviewMapper reviewMapper;

    @Override
    public String createReview(ReviewDto review) {
        if (review == null){
            throw new NotFound("Review is null");
        }
        Date now = new Date();
        Hotel hotel = hotelRepository.findById(review.getHotelId()).orElseThrow(()->new NotFound("no hotel found"));
        reviewRepository.save(Review
                .builder()
                        .rating(review.getRating())
                        .hotel(hotel)
                        .comment(review.getComment())
                        .email(review.getEmail())
                        .time(now)
                .build());
        return "Ok";
    }

    @Override
    public PageDto getReviews(long hotelId, int pagNumber) {
        if (hotelId <= 0){
            throw new NotFound("hotelId is null");
        }

        Pageable pageable = PageRequest.of(pagNumber,configMap.getPageSize());
        Page<Review> reviews = reviewRepository.findByHotelId(hotelId,pageable);
        List<ReviewDto> listReviews = reviews.getContent().stream().map(
                review -> reviewMapper.toEntity(review)
        ).collect(Collectors.toList());
        PageDto pageDto = new PageDto();
        pageDto.setPageNumber(pagNumber);
        pageDto.setPageSize(configMap.getPageSize());
        pageDto.setTotalElements(reviews.getTotalElements());
        pageDto.setContent(listReviews);
        pageDto.setNumberOfElements(reviews.getNumberOfElements());
        pageDto.setTotalPages(reviews.getTotalPages());
        return pageDto;
    }

    @Override
    public ReviewCount startHotelId(long hotelId) {
        if (hotelId <= 0){
            throw new NotFound("hotelId is null");
        }
        return  reviewRepository.getAverageRatingForHotel(hotelId) ;
    }

    @Override
    public Map<Integer, Integer> start_Sequentially(long hotelId) {
        if (hotelId <= 0){
            throw  new NotFound("hotelId is null");
        }

        Map<Integer, Integer> ratingCounts = new HashMap<>();
        for (int i = 1; i < 6; i++) {
            int count = reviewRepository.countHotel(i,hotelId);
            ratingCounts.put(i,count);
        }

        return ratingCounts;
    }

    @Override
    public int start(long userId, long reviewId) {
        if(userId <= 0 || reviewId <= 0){
            throw  new NotFound("userId and hotelId is null");
        }
        
        return 0;
    }


}
