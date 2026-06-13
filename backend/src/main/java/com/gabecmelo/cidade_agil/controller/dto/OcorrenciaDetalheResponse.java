package com.gabecmelo.cidade_agil.controller.dto;

import com.gabecmelo.cidade_agil.domain.Avaliacao;
import com.gabecmelo.cidade_agil.domain.Ocorrencia;
import com.gabecmelo.cidade_agil.domain.enums.Categoria;
import com.gabecmelo.cidade_agil.domain.enums.StatusOcorrencia;

import java.time.LocalDateTime;
import java.util.Base64;
import java.util.List;

public record OcorrenciaDetalheResponse(
        Long id,
        Categoria categoria,
        StatusOcorrencia status,
        String descricao,
        String fotoBase64,
        Integer prioridade,
        Double latitude,
        Double longitude,
        String enderecoFormatado,
        String bairro,
        LocalDateTime criadoEm,
        List<HistoricoStatusResponse> historico,
        AvaliacaoResponse avaliacao
) {
    public static OcorrenciaDetalheResponse from(Ocorrencia o, Avaliacao avaliacao) {
        String fotoBase64 = o.getFoto() != null ? Base64.getEncoder().encodeToString(o.getFoto()) : null;
        List<HistoricoStatusResponse> historico = o.getHistorico().stream()
                .map(HistoricoStatusResponse::from)
                .toList();
        AvaliacaoResponse avaliacaoResp = avaliacao != null ? AvaliacaoResponse.from(avaliacao) : null;
        return new OcorrenciaDetalheResponse(
                o.getId(),
                o.getCategoria(),
                o.getStatus(),
                o.getDescricao(),
                fotoBase64,
                o.getPrioridade(),
                o.getLocalizacao() != null ? o.getLocalizacao().getLatitude() : null,
                o.getLocalizacao() != null ? o.getLocalizacao().getLongitude() : null,
                o.getLocalizacao() != null ? o.getLocalizacao().getEnderecoFormatado() : null,
                o.getLocalizacao() != null ? o.getLocalizacao().getBairro() : null,
                o.getCriadoEm(),
                historico,
                avaliacaoResp
        );
    }
}
