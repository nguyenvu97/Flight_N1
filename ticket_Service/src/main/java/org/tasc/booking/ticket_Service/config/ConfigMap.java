package org.tasc.booking.ticket_Service.config;

import lombok.Data;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import redis.clients.jedis.Jedis;

@Data
@Configuration
public class ConfigMap {
    @Value("${appConfig.default-page-size}")

    public  int pageSize;
    @Value("${appConfig.default-page-number}")
    public   int pageNumber;


}
