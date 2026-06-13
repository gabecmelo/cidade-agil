package com.gabecmelo.cidade_agil.service.evento;

import com.gabecmelo.cidade_agil.domain.Ocorrencia;
import com.gabecmelo.cidade_agil.domain.Usuario;
import com.gabecmelo.cidade_agil.domain.enums.StatusOcorrencia;

public record StatusAlteradoEvent(
        Ocorrencia ocorrencia,
        StatusOcorrencia de,
        StatusOcorrencia para,
        Usuario responsavel,
        String observacao
) {}
