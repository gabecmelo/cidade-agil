package com.gabecmelo.cidade_agil.controller.dto;

import com.gabecmelo.cidade_agil.domain.enums.StatusOcorrencia;
import jakarta.validation.constraints.NotNull;

public record AtualizarStatusRequest(
        @NotNull StatusOcorrencia novoStatus,
        String observacao
) {}
