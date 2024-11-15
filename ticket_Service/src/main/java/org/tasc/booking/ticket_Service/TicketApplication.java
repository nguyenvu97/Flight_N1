package org.tasc.booking.ticket_Service;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.PropertySource;
import org.springframework.context.annotation.PropertySources;

@SpringBootApplication(
		scanBasePackages = {
				"org.tasc.booking.apiclient",
				"org.tasc.booking.ticket_Service"

		}
)
@EnableFeignClients(
		basePackages = "org.tasc.booking.apiclient"
)

public class TicketApplication {


	public static void main(String[] args) {
	
		SpringApplication.run(TicketApplication.class, args);


	}

}
