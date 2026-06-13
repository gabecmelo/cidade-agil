package com.gabecmelo.cidade_agil.controller.dto;

import com.gabecmelo.cidade_agil.domain.enums.TipoUsuario;

public record AuthResponse(
        String token,
        TipoUsuario tipoUsuario
) {}
