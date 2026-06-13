package com.gabecmelo.cidade_agil.controller;

import com.gabecmelo.cidade_agil.controller.dto.AuthResponse;
import com.gabecmelo.cidade_agil.controller.dto.LoginRequest;
import com.gabecmelo.cidade_agil.controller.dto.MeResponse;
import com.gabecmelo.cidade_agil.controller.dto.SignupRequest;
import com.gabecmelo.cidade_agil.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/signup")
    @ResponseStatus(HttpStatus.CREATED)
    public AuthResponse signup(@Valid @RequestBody SignupRequest request) {
        return authService.signup(request);
    }

    @PostMapping("/login")
    public AuthResponse login(@Valid @RequestBody LoginRequest request) {
        return authService.login(request);
    }

    @GetMapping("/me")
    public MeResponse me(@AuthenticationPrincipal UserDetails userDetails) {
        return authService.me(userDetails.getUsername());
    }
}
