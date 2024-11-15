package org.tasc.booking.ticket_Service.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.tasc.booking.ticket_Service.service.RedisService;

import java.util.List;
import java.util.Set;

@RestController
@RequestMapping("api/v1/assets")
@RequiredArgsConstructor
public class RedisAssetsController {
    public final RedisService redisService;

    @PostMapping("/add")
    public ResponseEntity<?> add(@RequestParam long flightId,@RequestParam(required = false)  String ticket_type_go,@RequestParam(required = false) String ticket_type_back, @RequestParam List<String> assets){
        return ResponseEntity.ok(redisService.block_assets(flightId, ticket_type_go, ticket_type_back, assets));
    }
    @GetMapping
    public ResponseEntity<?>get(@RequestParam long flightId){
        return  ResponseEntity.ok(redisService.get_list_assets(flightId));
    }
    @GetMapping("/list_assets")
    public ResponseEntity<?>get(@RequestParam long flightId,String ticket_type){
        return  ResponseEntity.ok(redisService.list_assets(flightId,ticket_type));
    }
    @DeleteMapping()
    public void delete(@RequestParam(value ="flightId") long flightId,@RequestParam(value = "assets") List<String> assets){
        redisService.delete_assets(flightId,assets);
    }
}
