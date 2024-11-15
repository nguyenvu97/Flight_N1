package org.tasc.booking.vnpay_Service.vnpay;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Map;

public class Test1 {
    public void read_flies() throws Notfound {
        try (FileReader file = new FileReader("abc/sda")) {
            int character;
            // Đọc từng ký tự từ tệp
            while ((character = file.read()) != -1) {
                System.out.print((char) character);
            }

        } catch (FileNotFoundException fileNotFoundException) {
            throw new Notfound(fileNotFoundException.getMessage(),400);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
    public void show(){
        try {
            read_flies();
        } catch (Notfound e) {
            throw new RuntimeException(e);
        }
    }

}
