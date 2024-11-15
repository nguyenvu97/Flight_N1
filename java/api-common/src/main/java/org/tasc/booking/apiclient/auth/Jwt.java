package org.tasc.booking.apiclient.auth;


import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.tasc.booking.apiclient.dto.MemberData;

@FeignClient(name = "user",url = "http://localhost:1001")
@Repository
public interface Jwt {
    @GetMapping("/api/v1/decode")
    MemberData decode(@RequestHeader("Authorization")String token);
}
