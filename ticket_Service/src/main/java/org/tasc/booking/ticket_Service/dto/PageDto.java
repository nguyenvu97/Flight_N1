package org.tasc.booking.ticket_Service.dto;

import java.util.List;

public class PageDto extends PagingDto {
    @SuppressWarnings("rawtypes")
    public List content;
    public long totalElements;

    public int number;
    public int numberOfElements;
    public int totalPages;
}
