package com.gabecmelo.cidade_agil.controller.dto;

import com.gabecmelo.cidade_agil.domain.Avaliacao;

import java.time.LocalDateTime;

public record AvaliacaoResponse(
        Short nota,
        String comentario,
        LocalDateTime criadoEm
) {
    public static AvaliacaoResponse from(Avaliacao a) {
        return new AvaliacaoResponse(a.getNota(), a.getComentario(), a.getCriadoEm());
    }
}
