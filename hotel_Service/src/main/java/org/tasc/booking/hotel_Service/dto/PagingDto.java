package org.tasc.booking.hotel_Service.dto;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Setter
@Getter
public class PagingDto {
    private int pageSize;
    private int pageNumber;
}
