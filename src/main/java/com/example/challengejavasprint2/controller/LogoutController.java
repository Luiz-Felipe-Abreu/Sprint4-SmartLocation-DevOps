package com.example.challengejavasprint2.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.client.OAuth2AuthorizedClientService;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class LogoutController {

    @Autowired(required = false)
    private OAuth2AuthorizedClientService authorizedClientService;

    @PostMapping("/logout")
    public String logout(HttpServletRequest request, HttpServletResponse response, Authentication authentication) {
        
        // Se o usuário está logado via OAuth2 (GitHub)
        if (authentication != null && authentication.getPrincipal() instanceof OAuth2User) {
            // Remove o cliente autorizado (revoga o token localmente)
            if (authorizedClientService != null) {
                try {
                    // Remove o cliente autorizado (isso remove o token localmente)
                    authorizedClientService.removeAuthorizedClient("github", authentication.getName());
                } catch (Exception e) {
                    // Ignora erros ao remover o cliente autorizado
                }
            }
        }
        
        // Faz logout do Spring Security
        if (authentication != null) {
            new SecurityContextLogoutHandler().logout(request, response, authentication);
        }
        
        if (request.getSession(false) != null) {
            request.getSession().invalidate();
        }
        
        return "redirect:/login?logout=true";
    }
}
