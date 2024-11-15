package org.tasc.booking.vnpay_Service.email;

import org.tasc.booking.apiclient.email.EmailDto;

public interface EmailSender {
    void sendemail(EmailDto emailDto);
}
