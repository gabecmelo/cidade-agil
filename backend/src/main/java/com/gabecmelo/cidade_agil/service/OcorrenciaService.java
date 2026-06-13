package com.gabecmelo.cidade_agil.service;

import com.gabecmelo.cidade_agil.config.exception.*;
import com.gabecmelo.cidade_agil.controller.dto.*;
import com.gabecmelo.cidade_agil.domain.Avaliacao;
import com.gabecmelo.cidade_agil.domain.Localizacao;
import com.gabecmelo.cidade_agil.domain.Ocorrencia;
import com.gabecmelo.cidade_agil.domain.Usuario;
import com.gabecmelo.cidade_agil.domain.enums.StatusOcorrencia;
import com.gabecmelo.cidade_agil.repository.AvaliacaoRepository;
import com.gabecmelo.cidade_agil.repository.OcorrenciaRepository;
import com.gabecmelo.cidade_agil.repository.UsuarioRepository;
import com.gabecmelo.cidade_agil.service.evento.StatusAlteradoEvent;
import com.gabecmelo.cidade_agil.service.priorizacao.PoliticaPriorizacao;
import lombok.RequiredArgsConstructor;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Base64;
import java.util.List;

@Service
@RequiredArgsConstructor
public class OcorrenciaService {

    private static final int LIMITE_FOTO_BYTES = 5 * 1024 * 1024;

    private final OcorrenciaRepository ocorrenciaRepository;
    private final UsuarioRepository usuarioRepository;
    private final AvaliacaoRepository avaliacaoRepository;
    private final PoliticaPriorizacao politicaPriorizacao;
    private final ApplicationEventPublisher eventPublisher;

    @Transactional
    public OcorrenciaResumoResponse criar(CriarOcorrenciaRequest req, String emailUsuario) {
        byte[] foto = decodificarFoto(req.fotoBase64());
        Usuario usuario = resolverUsuario(emailUsuario);

        Ocorrencia ocorrencia = Ocorrencia.builder()
                .categoria(req.categoria())
                .descricao(req.descricao())
                .foto(foto)
                .status(StatusOcorrencia.RECEBIDA)
                .localizacao(new Localizacao(req.latitude(), req.longitude(),
                        req.enderecoFormatado(), req.bairro()))
                .criadoPor(usuario)
                .build();

        ocorrencia.setPrioridade(politicaPriorizacao.calcular(ocorrencia));
        Ocorrencia salva = ocorrenciaRepository.save(ocorrencia);
        return OcorrenciaResumoResponse.from(salva);
    }

    @Transactional(readOnly = true)
    public List<OcorrenciaResumoResponse> listarMinhas(String emailUsuario) {
        Usuario usuario = resolverUsuario(emailUsuario);
        return ocorrenciaRepository.findByCriadoPorIdOrderByCriadoEmDesc(usuario.getId())
                .stream().map(OcorrenciaResumoResponse::from).toList();
    }

    @Transactional(readOnly = true)
    public List<OcorrenciaResumoResponse> listarFila() {
        return ocorrenciaRepository.findAllOrderByPrioridadeDesc()
                .stream().map(OcorrenciaResumoResponse::from).toList();
    }

    @Transactional(readOnly = true)
    public OcorrenciaDetalheResponse detalhe(Long id) {
        Ocorrencia o = ocorrenciaRepository.findDetalheById(id)
                .orElseThrow(() -> new OcorrenciaNaoEncontradaException(id));
        Avaliacao avaliacao = avaliacaoRepository.findByOcorrenciaId(id).orElse(null);
        return OcorrenciaDetalheResponse.from(o, avaliacao);
    }

    @Transactional
    public OcorrenciaResumoResponse atualizarStatus(Long id, AtualizarStatusRequest req, String emailUsuario) {
        Ocorrencia ocorrencia = ocorrenciaRepository.findDetalheById(id)
                .orElseThrow(() -> new OcorrenciaNaoEncontradaException(id));
        Usuario responsavel = resolverUsuario(emailUsuario);

        StatusOcorrencia anterior = ocorrencia.getStatus();
        ocorrencia.transicionarPara(req.novoStatus(), responsavel, req.observacao());

        ocorrenciaRepository.save(ocorrencia);

        eventPublisher.publishEvent(new StatusAlteradoEvent(
                ocorrencia, anterior, req.novoStatus(), responsavel, req.observacao()));

        return OcorrenciaResumoResponse.from(ocorrencia);
    }

    @Transactional
    public AvaliacaoResponse avaliar(Long id, CriarAvaliacaoRequest req, String emailUsuario) {
        Ocorrencia ocorrencia = ocorrenciaRepository.findDetalheById(id)
                .orElseThrow(() -> new OcorrenciaNaoEncontradaException(id));
        Usuario cidadao = resolverUsuario(emailUsuario);

        if (!ocorrencia.getCriadoPor().getId().equals(cidadao.getId())) {
            throw new NaoAutorizadoException();
        }
        if (avaliacaoRepository.existsByOcorrenciaId(id)) {
            throw new AvaliacaoJaExisteException(id);
        }

        Avaliacao avaliacao = Avaliacao.criar(ocorrencia, req.nota(), req.comentario());
        return AvaliacaoResponse.from(avaliacaoRepository.save(avaliacao));
    }

    private byte[] decodificarFoto(String fotoBase64) {
        byte[] foto;
        try {
            foto = Base64.getDecoder().decode(fotoBase64);
        } catch (IllegalArgumentException e) {
            throw new FotoMuitoGrandeException();
        }
        if (foto.length > LIMITE_FOTO_BYTES) {
            throw new FotoMuitoGrandeException();
        }
        return foto;
    }

    private Usuario resolverUsuario(String email) {
        return usuarioRepository.findByEmail(email)
                .orElseThrow(CredenciaisInvalidasException::new);
    }
}
