package org.tasc.booking.user_Service.auth;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class RegisterRequest {
    public String address;
    public String email;
    public String phone;
    public String password;
    public String fullName;
    public String country;
    public int role;
    public String aliases;
}
