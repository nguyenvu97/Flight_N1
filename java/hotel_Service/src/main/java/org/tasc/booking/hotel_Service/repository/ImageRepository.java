package org.tasc.booking.hotel_Service.repository;

import org.tasc.booking.hotel_Service.entity.Image;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ImageRepository extends JpaRepository<Image, Long> {
    Image findByImg(String imageName);
}
