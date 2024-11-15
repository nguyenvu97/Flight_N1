package org.tasc.booking.vnpay_Service.email;

import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import org.tasc.booking.apiclient.email.EmailDto;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@RequiredArgsConstructor
@Service
public class EmailService implements EmailSender {
    private final JavaMailSender mailSender;

    @Override
    @Async
    public void sendemail(EmailDto emailDto) {
        try{
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(mimeMessage,true,"utf-8");
            mimeMessageHelper.setTo(emailDto.getTo());
            mimeMessageHelper.setText(emailDto.getEmail(),true);
            mimeMessageHelper.setFrom("nguyenkhacvu1997@gmail.com");
            mimeMessageHelper.setSubject("thanh cong");
            mimeMessageHelper.setText(emailDto.getBody(),true);
            mailSender.send(mimeMessage);
        }catch (Exception e){
            throw new IllegalStateException("failed to send email" );
        }

    }
}
