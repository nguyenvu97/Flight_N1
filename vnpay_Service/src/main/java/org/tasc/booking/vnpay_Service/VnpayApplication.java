package org.tasc.booking.vnpay_Service;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.annotation.PropertySources;


@SpringBootApplication(
        scanBasePackages = {
                "org.tasc.booking.apiclient",
                "org.tasc.booking.vnpay_Service"
        }
)
@EnableFeignClients(
        basePackages = "org.tasc.booking.apiclient"
)

@PropertySources({
        @PropertySource("classpath:appClient-default.yml")
})
public class VnpayApplication {

    public static void main(String[] args) {
        SpringApplication.run(VnpayApplication.class, args);

    }

}
