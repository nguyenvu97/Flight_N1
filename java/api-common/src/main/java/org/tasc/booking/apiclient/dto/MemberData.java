package org.tasc.booking.apiclient.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.scheduling.annotation.Async;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class MemberData {
    private long id;
    private String name;
    private long iat;
    private long exp;
    private String sub;
    private String role;
    private String aliases;
    private String address;
    private String phone;

}