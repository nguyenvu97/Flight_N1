package org.tasc.booking.apiclient.dto;

import lombok.Data;

import java.util.List;
import java.util.Map;

@Data
public class CustomerDto {
    public  String fullName;
    public String aliases;
    public String  birthOfDay;
    private String email;
    private String phone;
    private String customType;
    private double amountTotal;
    public int bag_go;
    public int bag_back;
    public Map<Integer,String>  seats_go;
    public Map<Integer,String>  seats_go_child;
    public Map<Integer,String> seats_back;
    public Map<Integer,String> seats_back_child;
}
