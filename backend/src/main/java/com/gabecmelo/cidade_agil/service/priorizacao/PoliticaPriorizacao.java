package com.gabecmelo.cidade_agil.service.priorizacao;

import com.gabecmelo.cidade_agil.domain.Ocorrencia;

public interface PoliticaPriorizacao {
    int calcular(Ocorrencia ocorrencia);
}
