package org.tasc.booking.vnpay_Service.thread;

import org.tasc.booking.vnpay_Service.test.Customer;

import java.util.ArrayList;
import java.util.List;

public class CustomerManager {
    private static CustomerManager instance ;
    private List<Customer> customerList ;

    private CustomerManager() {
        this.customerList = new ArrayList<>();
    }
    public static CustomerManager getInstance() {
        if (instance == null) {
            synchronized (CustomerManager.class) {
                if (instance == null) {
                    instance = new CustomerManager();
                }
            }
        }
        return instance;
    }
    public  void addCustomer(Customer customer) {
        customerList.add(customer);
    }

    public List<Customer> getCustomers() {
        return new ArrayList<>(customerList);
    }
}
