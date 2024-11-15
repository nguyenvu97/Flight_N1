package org.tasc.booking.vnpay_Service.test;

import java.io.*;
import java.util.*;

public class CustomerManager {
    private static final String FILE_NAME = "/Volumes/Extreme SSD/javaCode/projectK4/vnpay_Service/src/main/resources/customer.txt";
    private static Map<String, Customer> customerMap = new HashMap<>();

    public static void main(String[] args) {
        loadCustomers();
        Scanner scanner = new Scanner(System.in);
        int choice;

        do {
            System.out.println("=== Customer Management ===");
            System.out.println("1. View Customers");
            System.out.println("2. Add Customers");
            System.out.println("3. Search Customer by Phone Number");
            System.out.println("4. Edit Customer");
            System.out.println("5. Delete Customer");
            System.out.println("0. Exit");
            System.out.print("Choose an option: ");
            choice = scanner.nextInt();
            scanner.nextLine(); // Clear the buffer

            switch (choice) {
                case 1:
                    viewCustomers();
                    break;
                case 2:
                    addCustomers(scanner);
                    break;
                case 3:
                    searchCustomer(scanner);
                    break;
                case 4:
                    editCustomer(scanner);
                    break;
                case 5:
                    deleteCustomer(scanner);
                    break;
                case 0:
                    System.out.println("Exiting...");
                    break;
                default:
                    System.out.println("Invalid choice! Please try again.");
            }
        } while (choice != 0);

        saveCustomers();
        scanner.close();
    }

    private static void loadCustomers() {
        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_NAME))) {
            String line;
            while ((line = reader.readLine()) != null) {
                Customer customer = parseCustomer(line);
                if (customer != null) {
                    customerMap.put(customer.getPhoneNumber(), customer);
                }
            }
        } catch (IOException e) {
            System.out.println("Could not load customers: " + e.getMessage());
        }
    }

    private static void saveCustomers() {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_NAME))) {
            for (Customer customer : customerMap.values()) {
                writer.write(customer.toJson());
                writer.newLine();
            }
        } catch (IOException e) {
            System.out.println("Could not save customers: " + e.getMessage());
        }
    }

    private static void viewCustomers() {
        if (customerMap.isEmpty()) {
            System.out.println("No customers found.");
        } else {
            for (Customer customer : customerMap.values()) {
                System.out.println(customer);
            }
        }
    }

    private static void addCustomers(Scanner scanner) {
        System.out.print("Enter number of customers to add: ");
        int n = scanner.nextInt();
        scanner.nextLine(); // Clear the buffer

        for (int i = 0; i < n; i++) {
            System.out.print("Enter name: ");
            String name = scanner.nextLine();
            String email;
            do {
                System.out.print("Enter email: ");
                email = scanner.nextLine();
            } while (!isValidEmail(email));

            String phoneNumber;
            do {
                System.out.print("Enter phone number (10 digits): ");
                phoneNumber = scanner.nextLine();
            } while (!isValidPhoneNumber(phoneNumber) || customerMap.containsKey(phoneNumber));

            customerMap.put(phoneNumber, new Customer(name, email, phoneNumber));
            System.out.println("Customer added successfully.");
        }
    }

    private static void searchCustomer(Scanner scanner) {
        System.out.print("Enter phone number to search: ");
        String phoneNumber = scanner.nextLine();
        Customer customer = customerMap.get(phoneNumber);
        if (customer != null) {
            System.out.println(customer);
        } else {
            System.out.println("Customer not found.");
        }
    }

    private static void editCustomer(Scanner scanner) {
        System.out.print("Enter phone number to edit: ");
        String phoneNumber = scanner.nextLine();
        Customer customer = customerMap.get(phoneNumber);
        if (customer != null) {
            System.out.print("New name (leave empty to keep the same): ");
            String newName = scanner.nextLine();
            if (!newName.isEmpty()) {
                customer = new Customer(newName, customer.getEmail(), customer.getPhoneNumber());
            }
            System.out.print("New email (leave empty to keep the same): ");
            String newEmail = scanner.nextLine();
            if (!newEmail.isEmpty() && isValidEmail(newEmail)) {
                customer = new Customer(customer.getName(), newEmail, customer.getPhoneNumber());
            }
            System.out.print("New phone number (leave empty to keep the same): ");
            String newPhoneNumber = scanner.nextLine();
            if (!newPhoneNumber.isEmpty() && isValidPhoneNumber(newPhoneNumber) && !customerMap.containsKey(newPhoneNumber)) {
                customerMap.remove(phoneNumber);
                customerMap.put(newPhoneNumber, new Customer(customer.getName(), customer.getEmail(), newPhoneNumber));
            } else {
                System.out.println("Phone number is invalid or already exists.");
            }
            System.out.println("Customer updated successfully.");
        } else {
            System.out.println("Customer not found.");
        }
    }

    private static void deleteCustomer(Scanner scanner) {
        System.out.print("Enter phone number to delete: ");
        String phoneNumber = scanner.nextLine();
        if (customerMap.remove(phoneNumber) != null) {
            System.out.println("Customer deleted successfully.");
        } else {
            System.out.println("Customer not found.");
        }
    }

    private static Customer parseCustomer(String json) {
        try {
            String[] parts = json.replaceAll("[{}\"]", "").split(",");
            String name = "", email = "", phoneNumber = "";

            for (String part : parts) {
                String[] keyValue = part.split(":");
                if (keyValue.length == 2) {
                    switch (keyValue[0].trim()) {
                        case "name":
                            name = keyValue[1].trim();
                            break;
                        case "email":
                            email = keyValue[1].trim();
                            break;
                        case "phoneNumber":
                            phoneNumber = keyValue[1].trim();
                            break;
                    }
                }
            }
            return new Customer(name, email, phoneNumber);
        } catch (Exception e) {
            return null;
        }
    }

    private static boolean isValidEmail(String email) {
        return email.matches("^[\\w-\\.]+@[\\w-]+\\.[a-z]{2,}$");
    }

    private static boolean isValidPhoneNumber(String phoneNumber) {
        return phoneNumber.matches("\\d{10}");
    }
}
