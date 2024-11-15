package org.tasc.booking.vnpay_Service.kafka;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class DateTimeUtils {
    public static String convertDateTimeToString(LocalDateTime dateTime) {
        if (dateTime != null) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            return dateTime.format(formatter);
        }
        return null;
    }
    public static LocalDateTime convertStringToDateTime(String dateTimeString) {
        if (dateTimeString != null && !dateTimeString.isEmpty()) {
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
            return LocalDateTime.parse(dateTimeString, formatter);
        }
        return null;
    }
}
