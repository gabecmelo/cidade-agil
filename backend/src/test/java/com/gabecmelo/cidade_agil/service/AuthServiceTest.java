package com.gabecmelo.cidade_agil.service;

import com.gabecmelo.cidade_agil.config.exception.CredenciaisInvalidasException;
import com.gabecmelo.cidade_agil.config.exception.EmailEmUsoException;
import com.gabecmelo.cidade_agil.config.security.JwtService;
import com.gabecmelo.cidade_agil.controller.dto.AuthResponse;
import com.gabecmelo.cidade_agil.controller.dto.LoginRequest;
import com.gabecmelo.cidade_agil.controller.dto.SignupRequest;
import com.gabecmelo.cidade_agil.domain.Usuario;
import com.gabecmelo.cidade_agil.domain.enums.TipoUsuario;
import com.gabecmelo.cidade_agil.repository.UsuarioRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AuthServiceTest {

    @Mock
    private UsuarioRepository usuarioRepository;
    @Mock
    private PasswordEncoder passwordEncoder;
    @Mock
    private JwtService jwtService;

    @InjectMocks
    private AuthService authService;

    @Test
    void signup_emailDuplicado_lancaEmailEmUsoException() {
        when(usuarioRepository.existsByEmail("teste@email.com")).thenReturn(true);

        SignupRequest request = new SignupRequest("Fulano", "teste@email.com", "senha123");

        assertThatThrownBy(() -> authService.signup(request))
                .isInstanceOf(EmailEmUsoException.class);

        verify(usuarioRepository, never()).save(any());
    }

    @Test
    void signup_dadosValidos_retornaTokenEtipo() {
        when(usuarioRepository.existsByEmail(anyString())).thenReturn(false);
        when(passwordEncoder.encode("senha123")).thenReturn("hash");
        when(usuarioRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        when(jwtService.generateToken(anyString())).thenReturn("token.jwt.gerado");

        SignupRequest request = new SignupRequest("Fulano", "novo@email.com", "senha123");

        AuthResponse response = authService.signup(request);

        assertThat(response.token()).isEqualTo("token.jwt.gerado");
        assertThat(response.tipoUsuario()).isEqualTo(TipoUsuario.CIDADAO);
    }

    @Test
    void login_emailNaoEncontrado_lancaCredenciaisInvalidasException() {
        when(usuarioRepository.findByEmail("naoexiste@email.com")).thenReturn(Optional.empty());

        LoginRequest request = new LoginRequest("naoexiste@email.com", "qualquercoisa");

        assertThatThrownBy(() -> authService.login(request))
                .isInstanceOf(CredenciaisInvalidasException.class);
    }

    @Test
    void login_senhaErrada_lancaCredenciaisInvalidasException() {
        Usuario usuario = Usuario.builder()
                .email("valido@email.com")
                .senhaHash("hash_correto")
                .tipo(TipoUsuario.CIDADAO)
                .build();

        when(usuarioRepository.findByEmail("valido@email.com")).thenReturn(Optional.of(usuario));
        when(passwordEncoder.matches("senha_errada", "hash_correto")).thenReturn(false);

        LoginRequest request = new LoginRequest("valido@email.com", "senha_errada");

        assertThatThrownBy(() -> authService.login(request))
                .isInstanceOf(CredenciaisInvalidasException.class);
    }

    @Test
    void login_credenciaisCorretas_retornaToken() {
        Usuario usuario = Usuario.builder()
                .email("valido@email.com")
                .senhaHash("hash_correto")
                .tipo(TipoUsuario.GESTOR)
                .build();

        when(usuarioRepository.findByEmail("valido@email.com")).thenReturn(Optional.of(usuario));
        when(passwordEncoder.matches("senha_certa", "hash_correto")).thenReturn(true);
        when(jwtService.generateToken("valido@email.com")).thenReturn("token.valido");

        AuthResponse response = authService.login(new LoginRequest("valido@email.com", "senha_certa"));

        assertThat(response.token()).isEqualTo("token.valido");
        assertThat(response.tipoUsuario()).isEqualTo(TipoUsuario.GESTOR);
    }
}
