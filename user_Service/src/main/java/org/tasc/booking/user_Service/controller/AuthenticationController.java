package org.tasc.booking.user_Service.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.tasc.booking.user_Service.auth.AuthenticationRequest;
import org.tasc.booking.user_Service.auth.AuthenticationResponse;
import org.tasc.booking.user_Service.auth.RegisterRequest;
import org.tasc.booking.user_Service.service.AuthenticationService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

@RestController
@RequestMapping("/api/v1")
@RequiredArgsConstructor
public class AuthenticationController {
    private final AuthenticationService service;

    @PostMapping("/register")
    public ResponseEntity<AuthenticationResponse> register(@RequestBody RegisterRequest request) {
        return ResponseEntity.ok(service.register(request));
    }
    @PostMapping("/login")
    public ResponseEntity<?> authenticate(@RequestBody AuthenticationRequest request, HttpServletResponse response) {
        return ResponseEntity.ok().body(service.login(request, response));
    }
    @PostMapping("/refresh-token")
    public void refreshToken(HttpServletRequest request, HttpServletResponse response) throws IOException {
        service.refreshToken(request, response);
    }
    @GetMapping("/logout")
    public void logoutUser(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
        service.logout(request, response, authentication);
    }


}
