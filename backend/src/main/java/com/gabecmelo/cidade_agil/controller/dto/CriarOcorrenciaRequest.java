package com.gabecmelo.cidade_agil.controller.dto;

import com.gabecmelo.cidade_agil.domain.enums.Categoria;
import jakarta.validation.constraints.*;

public record CriarOcorrenciaRequest(
        @NotNull Categoria categoria,
        @NotBlank @Size(max = 500) String descricao,
        @NotBlank String fotoBase64,
        @NotNull @DecimalMin("-90.0") @DecimalMax("90.0") Double latitude,
        @NotNull @DecimalMin("-180.0") @DecimalMax("180.0") Double longitude,
        String enderecoFormatado,
        String bairro
) {}
