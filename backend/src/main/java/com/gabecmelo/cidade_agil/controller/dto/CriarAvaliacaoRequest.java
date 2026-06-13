package com.gabecmelo.cidade_agil.controller.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record CriarAvaliacaoRequest(
        @NotNull @Min(1) @Max(5) Short nota,
        @Size(max = 300) String comentario
) {}
