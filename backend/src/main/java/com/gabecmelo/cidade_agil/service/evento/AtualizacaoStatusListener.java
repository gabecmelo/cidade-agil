package com.gabecmelo.cidade_agil.service.evento;

import com.gabecmelo.cidade_agil.repository.OcorrenciaRepository;
import com.gabecmelo.cidade_agil.service.priorizacao.PoliticaPriorizacao;
import lombok.RequiredArgsConstructor;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class AtualizacaoStatusListener {

    private final OcorrenciaRepository ocorrenciaRepository;
    private final PoliticaPriorizacao politicaPriorizacao;

    @EventListener
    public void onStatusAlterado(StatusAlteradoEvent evento) {
        var ocorrencia = evento.ocorrencia();
        int novaPrioridade = politicaPriorizacao.calcular(ocorrencia);
        ocorrencia.setPrioridade(novaPrioridade);
        ocorrenciaRepository.save(ocorrencia);
    }
}
