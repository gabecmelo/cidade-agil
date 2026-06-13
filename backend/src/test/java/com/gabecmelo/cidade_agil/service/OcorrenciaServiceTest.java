package com.gabecmelo.cidade_agil.service;

import com.gabecmelo.cidade_agil.config.exception.TransicaoStatusInvalidaException;
import com.gabecmelo.cidade_agil.controller.dto.AtualizarStatusRequest;
import com.gabecmelo.cidade_agil.domain.Localizacao;
import com.gabecmelo.cidade_agil.domain.Ocorrencia;
import com.gabecmelo.cidade_agil.domain.Usuario;
import com.gabecmelo.cidade_agil.domain.enums.Categoria;
import com.gabecmelo.cidade_agil.domain.enums.StatusOcorrencia;
import com.gabecmelo.cidade_agil.domain.enums.TipoUsuario;
import com.gabecmelo.cidade_agil.repository.AvaliacaoRepository;
import com.gabecmelo.cidade_agil.repository.OcorrenciaRepository;
import com.gabecmelo.cidade_agil.repository.UsuarioRepository;
import com.gabecmelo.cidade_agil.service.evento.StatusAlteradoEvent;
import com.gabecmelo.cidade_agil.service.priorizacao.PoliticaPriorizacao;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.ApplicationEventPublisher;

import java.time.LocalDateTime;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class OcorrenciaServiceTest {

    @Mock private OcorrenciaRepository ocorrenciaRepository;
    @Mock private UsuarioRepository usuarioRepository;
    @Mock private AvaliacaoRepository avaliacaoRepository;
    @Mock private PoliticaPriorizacao politicaPriorizacao;
    @Mock private ApplicationEventPublisher eventPublisher;

    @InjectMocks
    private OcorrenciaService ocorrenciaService;

    @Test
    void atualizarStatus_disparaObserverQueGravaHistorico() {
        Usuario gestor = Usuario.builder()
                .id(2L).nome("Gestor").email("gestor@city.com")
                .tipo(TipoUsuario.GESTOR).senhaHash("hash").build();

        Ocorrencia ocorrencia = Ocorrencia.builder()
                .id(1L)
                .categoria(Categoria.BURACO)
                .descricao("Buraco grande")
                .status(StatusOcorrencia.RECEBIDA)
                .criadoEm(LocalDateTime.now())
                .localizacao(new Localizacao(-23.0, -46.0, null, "Centro"))
                .criadoPor(gestor)
                .build();

        when(ocorrenciaRepository.findDetalheById(1L)).thenReturn(Optional.of(ocorrencia));
        when(usuarioRepository.findByEmail("gestor@city.com")).thenReturn(Optional.of(gestor));
        when(ocorrenciaRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        AtualizarStatusRequest req = new AtualizarStatusRequest(StatusOcorrencia.EM_ANALISE, "Analisando");
        ocorrenciaService.atualizarStatus(1L, req, "gestor@city.com");

        ArgumentCaptor<StatusAlteradoEvent> captor = ArgumentCaptor.forClass(StatusAlteradoEvent.class);
        verify(eventPublisher).publishEvent(captor.capture());

        StatusAlteradoEvent evento = captor.getValue();
        assertThat(evento.de()).isEqualTo(StatusOcorrencia.RECEBIDA);
        assertThat(evento.para()).isEqualTo(StatusOcorrencia.EM_ANALISE);
        assertThat(evento.responsavel()).isEqualTo(gestor);
    }

    @Test
    void atualizarStatus_transicaoInvalida_lancaExcecao() {
        Usuario gestor = Usuario.builder()
                .id(2L).nome("Gestor").email("gestor@city.com")
                .tipo(TipoUsuario.GESTOR).senhaHash("hash").build();

        Ocorrencia ocorrencia = Ocorrencia.builder()
                .id(1L)
                .categoria(Categoria.BURACO)
                .descricao("Buraco")
                .status(StatusOcorrencia.RECEBIDA)
                .criadoEm(LocalDateTime.now())
                .localizacao(new Localizacao(-23.0, -46.0, null, "Centro"))
                .criadoPor(gestor)
                .build();

        when(ocorrenciaRepository.findDetalheById(1L)).thenReturn(Optional.of(ocorrencia));
        when(usuarioRepository.findByEmail("gestor@city.com")).thenReturn(Optional.of(gestor));

        AtualizarStatusRequest req = new AtualizarStatusRequest(StatusOcorrencia.RESOLVIDA, null);

        org.assertj.core.api.Assertions.assertThatThrownBy(
                () -> ocorrenciaService.atualizarStatus(1L, req, "gestor@city.com"))
                .isInstanceOf(TransicaoStatusInvalidaException.class);

        verify(eventPublisher, never()).publishEvent(any());
    }
}
