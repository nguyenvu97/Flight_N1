package org.tasc.booking.vnpay_Service.thread;

import org.tasc.booking.vnpay_Service.test.Customer;
import org.tasc.booking.vnpay_Service.test.CustomerManager;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class Mycalss1 implements Runnable {
    private List<Customer> customers;

    public Mycalss1(List<Customer> customers) {
        this.customers = customers;
    }

    @Override
    public void run() {
        System.out.println("hshahsha myclass1");
        for (int i = 0; i < 10000; i++) {
            Customer customer = new Customer("name"+i,"email"+i,"093883"+i);
            customers.add(customer);
        }



    }


    public static void main(String[] args) {
        List<Customer> customers = new ArrayList<>();
        Thread thread = new Thread(new Mycalss1(customers));
        thread.start();
        try {
            thread.join();  // Đợi thread kết thúc
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        System.out.println(customers);



    }


}
