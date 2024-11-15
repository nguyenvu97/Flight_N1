package org.tasc.booking.ticket_Service.service.impl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.tasc.booking.apiclient.ex.EntityNotFound;
import org.tasc.booking.ticket_Service.service.RedisService;
import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPool;

import java.util.*;

import static org.tasc.booking.apiclient.ex.ExceptionMessagesEnum.ASSETS_ALREADY_EXISTS;
import static org.tasc.booking.ticket_Service.config.RedisConfig.*;

@Service
@RequiredArgsConstructor
@Slf4j
public class RedisServiceImpl implements RedisService {
    private  final Jedis jedis;



    @Override
    @Async
    public String block_assets(long flightId, String ticket_type_go, String ticket_type_back, List<String> assets) {

        Map<String,String> hashMap = new HashMap<>();
        Map<String,String> map_data_assets = get_list_assets(flightId);

        for (var data_assets : assets) {
            if (map_data_assets.containsKey(data_assets)) {
                throw  new EntityNotFound(ASSETS_ALREADY_EXISTS.getDescription(),200);
            }

        }
        if (ticket_type_go != null){
            for (String assets_data :assets){
                hashMap.put(assets_data,ticket_type_go);
                jedis.hset(key+flightId,hashMap);

            }
            jedis.expire(key + flightId, 600);
            return "ok";
        }else {
            for (String assets_data :assets) {
                hashMap.put(assets_data, ticket_type_back);
                jedis.hset(key+flightId,hashMap);
            }
            jedis.expire(key + flightId, 600);
            return "ok";
        }



    }

    @Override
    @Async
    public Map<String,String> get_list_assets( long flightId) {
        Map<String,String> hashMap = new HashMap<>();
        hashMap = jedis.hgetAll(key + flightId);
        return hashMap;
    }

    @Override
    @Async
    public List<String> list_assets(long flightId, String ticket_type) {
        Map<String,String> hashMap = get_list_assets(flightId);
        Set<String> data_assets = new HashSet<>();
        for (Map.Entry<String,String> value : hashMap.entrySet()) {
            if (value.getValue().contains(ticket_type)){
                data_assets.add(value.getKey());
            }
        }
        return data_assets.stream().toList();
    }

    @Override
    public void delete_assets(long flightId, List<String> assets) {
        Map<String,String> hashMap = get_list_assets(flightId);
        for (String assets_data : assets){
            if (hashMap.containsKey(assets_data)){
                jedis.hdel(key+flightId,assets_data);
            }
        }
    }
}
