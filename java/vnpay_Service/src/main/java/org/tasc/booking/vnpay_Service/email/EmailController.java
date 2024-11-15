package org.tasc.booking.vnpay_Service.email;

import lombok.RequiredArgsConstructor;
import org.tasc.booking.apiclient.email.EmailDto;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("api/v1/email")
@RequiredArgsConstructor
public class EmailController {
    private final EmailService emailService;

    @GetMapping
    public void sendEmail(@RequestBody EmailDto emailDto) {

        emailService.sendemail(emailDto);
    }

}
