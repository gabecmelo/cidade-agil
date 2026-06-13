package com.gabecmelo.cidade_agil.controller.dto;

import com.gabecmelo.cidade_agil.domain.enums.TipoUsuario;

public record MeResponse(
        Long id,
        String nome,
        String email,
        TipoUsuario tipo
) {}
