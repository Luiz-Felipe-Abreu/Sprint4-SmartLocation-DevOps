package com.example.challengejavasprint2.model;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "motos")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Moto {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @NotBlank(message = "Modelo é obrigatório")
    @Column(nullable = false)
    private String modelo;
    
    @NotBlank(message = "Placa é obrigatória")
    @Column(nullable = false, unique = true)
    private String placa;
    
    @Column(nullable = false)
    private String status = "DISPONIVEL"; // DISPONIVEL, EM_USO, MANUTENCAO
    
    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();
    
    private String observacoes;
}
