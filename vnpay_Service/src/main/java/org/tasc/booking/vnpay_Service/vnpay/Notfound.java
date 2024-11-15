package org.tasc.booking.vnpay_Service.vnpay;

public class Notfound extends Exception {
        int status_code;


    public Notfound( String message,int status_code) {
        super(message);
        this.status_code = status_code;
    }

}
