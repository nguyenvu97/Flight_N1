package org.tasc.booking.user_Service.service;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.tasc.booking.user_Service.auth.AuthenticationRequest;
import org.tasc.booking.user_Service.auth.AuthenticationResponse;
import org.tasc.booking.user_Service.auth.RegisterRequest;
import org.springframework.security.core.Authentication;

import java.io.IOException;

public interface AuthenticationService {
     AuthenticationResponse register (RegisterRequest request);
    AuthenticationResponse login(AuthenticationRequest request, HttpServletResponse response);
    void logout(HttpServletRequest request, HttpServletResponse response, Authentication authentication);
    void refreshToken(HttpServletRequest request, HttpServletResponse response) throws IOException;
}
