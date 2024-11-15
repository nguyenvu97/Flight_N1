package org.tasc.booking.hotel_Service.dto;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Setter
@Getter
public class PageDto extends PagingDto{
    @SuppressWarnings("rawtypes")
    public List content;
    public long totalElements;
    public int number;
    public int numberOfElements;
    public int totalPages;


}
