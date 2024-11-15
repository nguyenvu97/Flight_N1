package org.tasc.booking.user_Service.entity;

import jakarta.persistence.*;
import lombok.*;
import org.tasc.booking.user_Service.status.Role;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;

@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
public class User implements UserDetails {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public long id;
    @Column(unique = true, nullable = false)
    public String email;
    @Column(unique = true, nullable = false)
    public String phone;
    private String address;
    public String password;
    public String fullName;
    public String aliases;
    public String country;
    public Role role;
    @OneToMany(mappedBy = "user")
    private List<Token> tokens;



    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return role.getAuthorities();
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
