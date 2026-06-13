package com.gabecmelo.cidade_agil.controller.dto;

import com.gabecmelo.cidade_agil.domain.HistoricoStatus;
import com.gabecmelo.cidade_agil.domain.enums.StatusOcorrencia;

import java.time.LocalDateTime;

public record HistoricoStatusResponse(
        StatusOcorrencia de,
        StatusOcorrencia para,
        String observacao,
        LocalDateTime dataHora,
        String nomeResponsavel
) {
    public static HistoricoStatusResponse from(HistoricoStatus h) {
        return new HistoricoStatusResponse(
                h.getDe(),
                h.getPara(),
                h.getObservacao(),
                h.getDataHora(),
                h.getResponsavel() != null ? h.getResponsavel().getNome() : null
        );
    }
}
