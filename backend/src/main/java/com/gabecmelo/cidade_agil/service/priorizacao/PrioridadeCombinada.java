package com.gabecmelo.cidade_agil.service.priorizacao;

import com.gabecmelo.cidade_agil.domain.Ocorrencia;
import com.gabecmelo.cidade_agil.domain.enums.Categoria;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;

@Component
public class PrioridadeCombinada implements PoliticaPriorizacao {

    @Override
    public int calcular(Ocorrencia ocorrencia) {
        int pesoCat = pesoPorCategoria(ocorrencia.getCategoria());
        long dias = ChronoUnit.DAYS.between(ocorrencia.getCriadoEm(), LocalDateTime.now());
        return (int) (pesoCat + dias * 2);
    }

    private int pesoPorCategoria(Categoria categoria) {
        return switch (categoria) {
            case BURACO, ALAGAMENTO -> 5;
            case VANDALISMO -> 4;
            case ILUMINACAO, CALCADA -> 3;
            case OUTRO -> 1;
        };
    }
}
