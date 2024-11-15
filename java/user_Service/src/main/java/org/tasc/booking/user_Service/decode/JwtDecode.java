//package org.springframework.boot.login.decode;
//
//import io.jsonwebtoken.Claims;
//import lombok.RequiredArgsConstructor;
//import org.springframework.boot.apiclient.dto.MemberData;
//import org.springframework.boot.apiclient.exception.NotFound;
//import org.springframework.boot.login.entity.User;
//import org.springframework.boot.login.repository.UserRepository;
//import org.springframework.boot.login.service.impl.JwtService;
//import org.springframework.web.bind.annotation.*;
//
//@RequiredArgsConstructor
//@RestController
//@RequestMapping("api/v1")
//public class JwtDecode {
//    private final JwtService jwtService;
//    private final UserRepository  userRepository;
//    @GetMapping("decode")
//    public MemberData decode (@RequestHeader(value = "Authorization") String token){
//        Claims claims = jwtService.extractToken(token);
//        User user = userRepository.findByEmail(claims.getSubject()).orElseThrow(()-> new NotFound("jwt not found"));
//        return  MemberData
//                .builder()
//                .id(user.getId())
//                .phone(user.getPhone())
//                .address(user.getAddress())
//                .fullName(user.getFullName())
//                .sub(claims.getSubject())
//                .iat(claims.getIssuedAt().getTime())
//                .exp(claims.getExpiration().getTime())
//                .role(String.valueOf(user.getRole()))
//                .aliases(user.getAliases())
//                .build();
//    }
//
//}


package org.tasc.booking.user_Service.decode;

import io.jsonwebtoken.Claims;
import lombok.RequiredArgsConstructor;

import org.tasc.booking.apiclient.dto.MemberData;
import org.tasc.booking.apiclient.ex.NotFound;
import org.tasc.booking.user_Service.entity.User;

import org.tasc.booking.user_Service.repository.UserRepository;
import org.tasc.booking.user_Service.service.impl.JwtService;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@RestController
@RequestMapping("api/v1")
public class JwtDecode {
    private final JwtService jwtService;
    private final UserRepository  userRepository;
    @GetMapping("decode")
    public MemberData decode (@RequestHeader(value = "Authorization") String token){
        Claims claims = jwtService.extractToken(token);
        User user = userRepository.findByEmail(claims.getSubject()).orElseThrow(()-> new NotFound("jwt not found"));
        return  MemberData
                .builder()
                .id(user.getId())
                .role(user.getRole().name())
                .name(user.fullName)
                .address(user.getAddress())
                .phone(user.getPhone())
                .aliases(user.getAliases())
                .sub(claims.getSubject())
                .iat(claims.getIssuedAt().getTime())
                .exp(claims.getExpiration().getTime())
                .build();

    }
}
