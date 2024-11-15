package org.tasc.booking.user_Service.repository;

import org.tasc.booking.user_Service.entity.Token;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TokenRepository extends JpaRepository<Token, Long> {
    @Query("SELECT t FROM Token t JOIN t.user u WHERE u.id = :id AND (t.expired = false OR t.revoked = false)")
    List<Token> findAllValidTokenByUser(@Param(value = "id") long id);

    Optional<Token> findByToken(String token);
}
