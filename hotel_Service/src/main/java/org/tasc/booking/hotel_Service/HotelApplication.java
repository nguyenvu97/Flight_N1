package org.tasc.booking.hotel_Service;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.annotation.PropertySources;

@SpringBootApplication(
		scanBasePackages = {
				"org.tasc.booking.apiclient",
				"org.tasc.booking.hotel_Service"
		}
)


@EnableFeignClients(
		basePackages = "org.tasc.booking.apiclient"
)

@PropertySources({
		@PropertySource("classpath:appClient-default.yml")
})
public class HotelApplication {

	public static void main(String[] args) {
		SpringApplication.run(HotelApplication.class, args);
	}

}
