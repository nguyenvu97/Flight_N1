package org.tasc.booking.ticket_Service.service;

import java.util.List;
import java.util.Map;
import java.util.Set;

public interface RedisService {
    String block_assets(long flightId, String ticket_type_go , String ticket_type_back ,List<String> assets);
    Map<String,String> get_list_assets(long flightId);

    List<String>list_assets(long flightId,String ticket_type);
    void delete_assets(long flightId,List<String> assets);
}
