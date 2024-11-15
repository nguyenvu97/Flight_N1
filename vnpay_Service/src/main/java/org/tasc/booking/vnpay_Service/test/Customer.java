package org.tasc.booking.vnpay_Service.test;

public class Customer {
    private String name;
    private String email;
    private String phoneNumber;

    public Customer(String name, String email, String phoneNumber) {
        this.name = name;
        this.email = email;
        this.phoneNumber = phoneNumber;
    }

    public String getName() {
        return name;
    }

    public String getEmail() {
        return email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public String toJson() {
        return "{\"name\": \"" + name + "\", \"email\": \"" + email + "\", \"phoneNumber\": \"" + phoneNumber + "\"}";
    }

    @Override
    public String toString() {
        return "Name: " + name + ", Email: " + email + ", Phone Number: " + phoneNumber;
    }
}
