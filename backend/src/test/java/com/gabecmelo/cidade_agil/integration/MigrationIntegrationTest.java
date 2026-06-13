package com.gabecmelo.cidade_agil.integration;

import com.gabecmelo.cidade_agil.domain.Usuario;
import com.gabecmelo.cidade_agil.domain.enums.TipoUsuario;
import com.gabecmelo.cidade_agil.repository.UsuarioRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.test.context.DynamicPropertyRegistry;
import org.springframework.test.context.DynamicPropertySource;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@SpringBootTest
@Testcontainers
class MigrationIntegrationTest {

    @Container
    static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>("postgres:16")
            .withDatabaseName("cidadeagil_test")
            .withUsername("cidadeagil")
            .withPassword("cidadeagil");

    @DynamicPropertySource
    static void configureDataSource(DynamicPropertyRegistry registry) {
        registry.add("spring.datasource.url", postgres::getJdbcUrl);
        registry.add("spring.datasource.username", postgres::getUsername);
        registry.add("spring.datasource.password", postgres::getPassword);
    }

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Test
    void migracaoV1_schemaValido_contextSobe() {
        // Se o contexto subiu, ddl-auto=validate passou — schema bate com as entidades.
        assertThat(usuarioRepository).isNotNull();
    }

    @Test
    void constraintUnicaEmail_emailDuplicado_lancaExcecao() {
        Usuario u1 = Usuario.builder()
                .nome("Primeiro")
                .email("duplicado@teste.com")
                .senhaHash("hash")
                .tipo(TipoUsuario.CIDADAO)
                .build();

        Usuario u2 = Usuario.builder()
                .nome("Segundo")
                .email("duplicado@teste.com")
                .senhaHash("hash")
                .tipo(TipoUsuario.CIDADAO)
                .build();

        usuarioRepository.saveAndFlush(u1);

        assertThatThrownBy(() -> usuarioRepository.saveAndFlush(u2))
                .isInstanceOf(DataIntegrityViolationException.class);
    }
}
