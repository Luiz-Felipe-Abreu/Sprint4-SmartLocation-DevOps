package com.example.challengejavasprint2.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.challengejavasprint2.model.PerfilUsuario;
import com.example.challengejavasprint2.repository.PerfilUsuarioRepository;

@Service
public class PerfilUsuarioService {

    @Autowired
    private PerfilUsuarioRepository perfilUsuarioRepository;

    public PerfilUsuario buscarOuCriarPerfil(String githubUsername, String githubName) {
        return perfilUsuarioRepository.findByGithubUsername(githubUsername)
            .orElseGet(() -> {
                PerfilUsuario novoPerfil = new PerfilUsuario();
                novoPerfil.setGithubUsername(githubUsername);
                novoPerfil.setNomeCompleto(githubName);
                return perfilUsuarioRepository.save(novoPerfil);
            });
    }

    public PerfilUsuario atualizarPerfil(PerfilUsuario perfilExistente, PerfilUsuario perfilNovo, String githubName) {
        perfilExistente.setNomeCompleto(perfilNovo.getNomeCompleto() != null && !perfilNovo.getNomeCompleto().trim().isEmpty()
            ? perfilNovo.getNomeCompleto() : githubName);
        perfilExistente.setEmail(perfilNovo.getEmail());
        perfilExistente.setTelefone(perfilNovo.getTelefone());
        perfilExistente.setCargo(perfilNovo.getCargo());
        return perfilUsuarioRepository.save(perfilExistente);
    }
}