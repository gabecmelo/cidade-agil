package com.gabecmelo.cidade_agil.controller.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record SignupRequest(
        @NotBlank(message = "Nome é obrigatório.")
        @Size(max = 120, message = "Nome deve ter no máximo 120 caracteres.")
        String nome,

        @NotBlank(message = "E-mail é obrigatório.")
        @Email(message = "E-mail inválido.")
        String email,

        @NotBlank(message = "Senha é obrigatória.")
        @Size(min = 6, message = "Senha deve ter no mínimo 6 caracteres.")
        String senha
) {}
