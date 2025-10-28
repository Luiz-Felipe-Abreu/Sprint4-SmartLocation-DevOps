package com.example.challengejavasprint2.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.Email;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "perfil_usuario")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class PerfilUsuario {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "github_username", unique = true)
    private String githubUsername;
    
    @Column(name = "nome_completo")
    private String nomeCompleto;
    
    @Email
    @Column(name = "email")
    private String email;
    
    @Column(name = "telefone")
    private String telefone;
    
    @Column(name = "cargo")
    private String cargo;
    
    
}
