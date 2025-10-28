package com.example.challengejavasprint2.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.example.challengejavasprint2.model.Moto;

@Repository
public interface MotoRepository extends JpaRepository<Moto, Long> {

    // Buscar motos por status
    List<Moto> findByStatus(String status);

    // Buscar motos por modelo
    List<Moto> findByModeloContainingIgnoreCase(String modelo);

    // Contar motos por status
    @Query("SELECT COUNT(m) FROM Moto m WHERE m.status = ?1")
    long countByStatus(String status);

    // Buscar moto por placa
    Moto findByPlaca(String placa);

    // Verificar se existe moto com placa específica, excluindo um ID específico (para edição)
    @Query("SELECT COUNT(m) FROM Moto m WHERE m.placa = ?1 AND m.id != ?2")
    long countByPlacaAndIdNot(String placa, Long id);

    // Verificar se existe moto com placa específica
    boolean existsByPlaca(String placa);
}