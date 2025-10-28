package com.example.challengejavasprint2.repository;

import com.example.challengejavasprint2.model.PerfilUsuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface PerfilUsuarioRepository extends JpaRepository<PerfilUsuario, Long> {
    
    Optional<PerfilUsuario> findByGithubUsername(String githubUsername);
    
    boolean existsByGithubUsername(String githubUsername);
}
