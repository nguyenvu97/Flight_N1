package org.tasc.booking.user_Service.service.impl;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

import org.tasc.booking.apiclient.email.EmailClient;
import org.tasc.booking.apiclient.email.EmailDto;
import org.tasc.booking.user_Service.status.Role;
import org.tasc.booking.user_Service.status.TokenType;
import org.tasc.booking.user_Service.auth.AuthenticationRequest;
import org.tasc.booking.user_Service.auth.AuthenticationResponse;
import org.tasc.booking.user_Service.auth.RegisterRequest;
import org.tasc.booking.user_Service.entity.Token;
import org.tasc.booking.user_Service.entity.User;
import org.tasc.booking.user_Service.repository.TokenRepository;
import org.tasc.booking.user_Service.repository.UserRepository;
import org.tasc.booking.user_Service.service.AuthenticationService;
import org.springframework.http.HttpHeaders;
import org.springframework.scheduling.annotation.Async;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.logout.LogoutHandler;
import org.springframework.stereotype.Service;

import java.io.IOException;

@RequiredArgsConstructor
@Service
@Transactional
public class AuthenticationServiceImpl implements AuthenticationService,LogoutHandler {
    public  final UserRepository userDao;
    public final TokenRepository tokenRepository;
    public  final JwtService jwtService;
    public final PasswordEncoder passwordEncoder;
    public final AuthenticationManager authenticationManager;
    public final EmailClient emailClient;

    @Override
    @Async
    public AuthenticationResponse register(RegisterRequest request) {
        if (request.getRole() == 0){
            var user = userDao.save(User
                    .builder()
                    .email(request.getEmail())
                    .phone(request.getPhone())
                    .role(Role.USER)
                    .aliases(request.getAddress())
                    .password(passwordEncoder.encode(request.getPassword()))
                    .fullName(request.getFullName())
                    .address(request.getAddress())
                    .country(request.getCountry())
                    .aliases(request.getAliases())
                    .build());
            var jwt = jwtService.generateToken(user);
            var refreshToken = jwtService.generateRefreshToken(user);
            String body = "<!DOCTYPE html>\n" + "<html>\n" + "<head>\n" + "    <title>Đăng ký thành công </title>\n" + "    <style>\n" + "        body {\n" + "            font-family: Arial, sans-serif;\n" + "            text-align: center;\n" + "        }\n" + "        h1 {\n" + "            color: #008000;\n" + "        }\n" + "    </style>\n" + "</head>\n" + "<body>\n" + "    <h1>Đăng ký thành công</h1>\n" + "    <p>Cảm ơn bạn đã đăng ký thành công!</p>\n" + "    <p>Bạn có thể đăng nhập vào tài khoản của mình ngay bây giờ.</p>\n" + "</body>\n" + "</html>\n";
            EmailDto emailDto = new EmailDto();
            emailDto.setEmail(request.getEmail());
            emailDto.setTo(request.getEmail());
            emailDto.setBody(body);
            emailClient.email(emailDto);
            return AuthenticationResponse
                    .builder()
                    .accessToken(jwt)
                    .refreshToken(refreshToken)
                    .build();
        }
            var user = userDao.save(User
                    .builder()
                    .email(request.getEmail())
                    .phone(request.getPhone())
                    .role(Role.ADMIN)
                    .aliases(request.getAddress())
                    .password(passwordEncoder.encode(request.getPassword()))
                    .fullName(request.getFullName())
                    .address(request.getAddress())
                    .country(request.getCountry())
                    .aliases(request.getAliases())
                    .build());

            var jwt = jwtService.generateToken(user);
            var refreshToken = jwtService.generateRefreshToken(user);

        return AuthenticationResponse
                .builder()
                .accessToken(jwt)
                .refreshToken(refreshToken)
                .build();
    }

    @Override
    public AuthenticationResponse login(AuthenticationRequest request, HttpServletResponse response) {
        authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword()));
        var user = userDao.findByEmail(request.getEmail()).orElseThrow();
        var jwtToken = jwtService.generateToken(user);
        var refreshToken = jwtService.generateRefreshToken(user);
        revokeAllUserTokens(user);
        saveUserToken(user, jwtToken);
        return AuthenticationResponse
                .builder()
                .accessToken(jwtToken)
                .refreshToken(refreshToken)
                .build();
    }

    private void saveUserToken(User user, String jwtToken) {
        var token = Token.builder().user(user).token(jwtToken).tokenType(TokenType.BEARER).expired(false).revoked(false).build();
        tokenRepository.save(token);
    }

    private void revokeAllUserTokens(User user) {
        var validUserTokens = tokenRepository.findAllValidTokenByUser(user.getId());
        if (validUserTokens.isEmpty()) return;
        validUserTokens.forEach(token -> {
            token.setExpired(true);
            token.setRevoked(true);
        });
        tokenRepository.saveAll(validUserTokens);
    }
    @Async
    public void refreshToken(HttpServletRequest request, HttpServletResponse response) throws IOException {
        final String authHeader = request.getHeader(HttpHeaders.AUTHORIZATION);
        final String refreshToken;
        final String userEmail;
        if (authHeader == null || !authHeader.startsWith("Bearer")) {
            return;
        }
        refreshToken = authHeader.substring(7);
        userEmail = jwtService.extracUsername(refreshToken);
        if (userEmail != null) {
            var user = this.userDao.findByEmail(userEmail).orElseThrow();
            if (jwtService.isTokenValid(refreshToken, user)) {
                var accessToken = jwtService.generateToken(user);
                revokeAllUserTokens(user);
                saveUserToken(user, accessToken);
                var authResponse = AuthenticationResponse.builder().accessToken(accessToken).refreshToken(refreshToken).build();
                new ObjectMapper().writeValue(response.getOutputStream(), authResponse);
            }
        }
    }

    @Override
    @Async
    public void logout(HttpServletRequest request, HttpServletResponse response, Authentication authentication) {
        final  String authHeader = request.getHeader("Authorization");
        final String jwt;
        if (authHeader == null && !authHeader.startsWith("Bearer ")){
            return;
        }
        jwt = authHeader.substring(7);
        var storedToken = tokenRepository.findByToken(jwt).orElse(null);
        if (storedToken != null){
            storedToken.setExpired(true);
            storedToken.setRevoked(true);
            tokenRepository.save(storedToken);
            SecurityContextHolder.clearContext();
        }
    }
}
