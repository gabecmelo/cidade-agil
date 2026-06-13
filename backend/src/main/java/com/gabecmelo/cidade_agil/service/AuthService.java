package com.gabecmelo.cidade_agil.service;

import com.gabecmelo.cidade_agil.config.exception.CredenciaisInvalidasException;
import com.gabecmelo.cidade_agil.config.exception.EmailEmUsoException;
import com.gabecmelo.cidade_agil.config.security.JwtService;
import com.gabecmelo.cidade_agil.controller.dto.AuthResponse;
import com.gabecmelo.cidade_agil.controller.dto.LoginRequest;
import com.gabecmelo.cidade_agil.controller.dto.MeResponse;
import com.gabecmelo.cidade_agil.controller.dto.SignupRequest;
import com.gabecmelo.cidade_agil.domain.Usuario;
import com.gabecmelo.cidade_agil.domain.enums.TipoUsuario;
import com.gabecmelo.cidade_agil.repository.UsuarioRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    @Transactional
    public AuthResponse signup(SignupRequest request) {
        if (usuarioRepository.existsByEmail(request.email())) {
            throw new EmailEmUsoException(request.email());
        }

        Usuario usuario = Usuario.builder()
                .nome(request.nome())
                .email(request.email())
                .senhaHash(passwordEncoder.encode(request.senha()))
                .tipo(TipoUsuario.CIDADAO)
                .build();

        usuarioRepository.save(usuario);

        String token = jwtService.generateToken(usuario.getEmail());
        return new AuthResponse(token, usuario.getTipo());
    }

    @Transactional(readOnly = true)
    public AuthResponse login(LoginRequest request) {
        Usuario usuario = usuarioRepository.findByEmail(request.email())
                .orElseThrow(CredenciaisInvalidasException::new);

        if (!passwordEncoder.matches(request.senha(), usuario.getSenhaHash())) {
            throw new CredenciaisInvalidasException();
        }

        String token = jwtService.generateToken(usuario.getEmail());
        return new AuthResponse(token, usuario.getTipo());
    }

    @Transactional(readOnly = true)
    public MeResponse me(String email) {
        Usuario usuario = usuarioRepository.findByEmail(email)
                .orElseThrow(CredenciaisInvalidasException::new);

        return new MeResponse(usuario.getId(), usuario.getNome(), usuario.getEmail(), usuario.getTipo());
    }
}
