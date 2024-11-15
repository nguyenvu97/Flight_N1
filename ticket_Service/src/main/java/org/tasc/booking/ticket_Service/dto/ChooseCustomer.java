package org.tasc.booking.ticket_Service.dto;

import lombok.Data;

@Data
public class ChooseCustomer {
    public long customerId;
    public String ticket_type;
}
