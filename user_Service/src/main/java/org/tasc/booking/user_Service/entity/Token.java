package org.tasc.booking.user_Service.entity;

import jakarta.persistence.*;
import lombok.*;
import org.tasc.booking.user_Service.status.TokenType;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
@Entity
public class Token {
    @Id
    @SequenceGenerator(name = "token_id_name",sequenceName = "token_id_name")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    @Column(unique = true)
    private String token;
    @Enumerated(EnumType.STRING)
    public TokenType tokenType = TokenType.BEARER;

    public boolean revoked;

    public boolean expired;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    public User user;
}
