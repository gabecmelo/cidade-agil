package com.gabecmelo.cidade_agil.controller.dto;

import com.gabecmelo.cidade_agil.domain.Ocorrencia;
import com.gabecmelo.cidade_agil.domain.enums.Categoria;
import com.gabecmelo.cidade_agil.domain.enums.StatusOcorrencia;

import java.time.LocalDateTime;

public record OcorrenciaResumoResponse(
        Long id,
        Categoria categoria,
        StatusOcorrencia status,
        String descricao,
        Integer prioridade,
        String bairro,
        LocalDateTime criadoEm
) {
    public static OcorrenciaResumoResponse from(Ocorrencia o) {
        return new OcorrenciaResumoResponse(
                o.getId(),
                o.getCategoria(),
                o.getStatus(),
                o.getDescricao(),
                o.getPrioridade(),
                o.getLocalizacao() != null ? o.getLocalizacao().getBairro() : null,
                o.getCriadoEm()
        );
    }
}
