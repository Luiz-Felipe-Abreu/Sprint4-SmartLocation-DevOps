package com.example.challengejavasprint2.util;

import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.ui.Model;

public class GithubUserModelHelper {
    public static void addGithubUserInfo(Model model, Authentication authentication) {
        if (authentication != null && authentication.getPrincipal() instanceof OAuth2User oauth2User) {
            model.addAttribute("githubUser", oauth2User);
            model.addAttribute("userAvatar", oauth2User.getAttribute("avatar_url"));
            model.addAttribute("userName", oauth2User.getAttribute("name"));
            model.addAttribute("userLogin", oauth2User.getAttribute("login"));
        }
    }

    public static String getGithubUsername(Authentication authentication) {
        if (authentication != null && authentication.getPrincipal() instanceof OAuth2User oauth2User) {
            return oauth2User.getAttribute("login");
        }
        return null;
    }

    public static String getGithubName(Authentication authentication) {
        if (authentication != null && authentication.getPrincipal() instanceof OAuth2User oauth2User) {
            return oauth2User.getAttribute("name");
        }
        return null;
    }
}