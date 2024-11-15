package org.tasc.booking.hotel_Service.spec;


import jakarta.persistence.criteria.*;
import org.tasc.booking.hotel_Service.dto.request.HotelSearch;
import org.tasc.booking.hotel_Service.entity.Hotel;
import org.tasc.booking.hotel_Service.entity.Review;
import org.tasc.booking.hotel_Service.entity.Room;
import org.springframework.data.jpa.domain.Specification;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;


public class HotelSpec {


    public static Specification<Hotel> searchHotelRoom1(HotelSearch searchDto, int sortId) {
        return (root, query, builder) -> {
            // Subquery để tính điểm trung bình

            Subquery<Number> avgRatingSubquery = query.subquery(Number.class);
            Root<Review> reviewRoot = avgRatingSubquery.from(Review.class);
            avgRatingSubquery.select(
                    builder.quot(
                            builder.coalesce(builder.sum(reviewRoot.get("rating")), 0.0),
                            builder.coalesce(builder.count(reviewRoot.get("hotel")), 1.0)
                    )

            ).where(builder.equal(reviewRoot.get("hotel"), root));
            Subquery<Long>countReviews = query.subquery(Long.class);

            Root<Review> reviewCount = countReviews.from(Review.class);
            countReviews.select(
                   builder.count(reviewCount.get("rating")
            )
            ).where(builder.equal(reviewCount.get("hotel"), root));


            // Thực hiện các điều kiện lọc
            List<Predicate> predicates = new ArrayList<>();
            if (searchDto.getAddress() != null && !searchDto.getAddress().isEmpty()) {
                predicates.add(builder.like(root.get("address"), "%" + searchDto.getAddress() + "%"));
            }

            // Join với Room
            Join<Hotel, Room> roomJoin = root.join("room", JoinType.INNER);

            if (searchDto.getCategoryType() != null) {
                predicates.add(builder.equal(roomJoin.get("categoryType"), searchDto.getCategoryType()));
            }
            if (searchDto.getNumberRoom() > 0) {
                predicates.add(builder.greaterThanOrEqualTo(roomJoin.get("numberRoom"), searchDto.getNumberRoom()));
            }
            if (searchDto.getNumberPeople() > 0) {
                predicates.add(builder.greaterThanOrEqualTo(roomJoin.get("numberPeople"), searchDto.getNumberPeople()));
            }
            if (searchDto.getMaxMoney() > 0  && searchDto.getMinMoney() > 0 ){
                if (searchDto.getMaxMoney() > searchDto.getMinMoney()) {
                    predicates.add(builder.between(roomJoin.get("price"), searchDto.getMinMoney(), searchDto.getMaxMoney()));
                }
            }
            if (searchDto.getStartTime() != null && !searchDto.getStartTime().isEmpty()) {
                LocalDate startDate = LocalDate.parse(searchDto.getStartTime());
                predicates.add(builder.lessThanOrEqualTo(roomJoin.get("startTime"), startDate));
            }
            if (searchDto.getEndTime() != null && !searchDto.getEndTime().isEmpty()) {
                LocalDate endDate = LocalDate.parse(searchDto.getEndTime());
                predicates.add(builder.greaterThanOrEqualTo(roomJoin.get("endTime"), endDate));
            }
            if (searchDto.getStartHotel() > 0) {
                predicates.add(builder.ge(avgRatingSubquery, searchDto.getStartHotel()));
            }
            switch (sortId){

                //todo gia tien desc
                case 1 :
                    query.orderBy(
                    builder.desc(roomJoin.get("price")));
                    break;
                    // todo gia tien asc
                case 2 :
                    query.orderBy(
                            builder.asc(roomJoin.get("price")));
                    break;
                    // todo best start and price lowest
                case 3 :
                    query.orderBy(
                            builder.desc(avgRatingSubquery),
                            builder.asc(roomJoin.get("price"))
                    );
                    break;
                    // top reviews
                case 4 :
                    query.orderBy(
                            builder.desc(countReviews)
                    );

                    break;
                    // coutn revew vs gai tien thap
                case 5:
                    query.orderBy(
                            builder.desc(countReviews),
                            builder.asc(roomJoin.get("price"))
                    );

                    break;
                default: query.orderBy(builder.asc(root.get("id")));
                    break;
            }
            query.where(predicates.toArray(new Predicate[0]));

            return query.getRestriction();
        };
    }
}


