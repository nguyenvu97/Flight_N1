package org.tasc.booking.ticket_Service.dto.Requet;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SearchFlight {
    public String startDate;
    public String endDate;
    public String departure;
    public String arrival;
    public int adultQuantity = 1;
    public int childQuantity = 0;

}
