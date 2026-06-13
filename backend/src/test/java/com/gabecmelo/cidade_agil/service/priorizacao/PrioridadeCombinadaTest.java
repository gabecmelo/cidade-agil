package com.gabecmelo.cidade_agil.service.priorizacao;

import com.gabecmelo.cidade_agil.domain.Localizacao;
import com.gabecmelo.cidade_agil.domain.Ocorrencia;
import com.gabecmelo.cidade_agil.domain.enums.Categoria;
import com.gabecmelo.cidade_agil.domain.enums.StatusOcorrencia;
import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;

import static org.assertj.core.api.Assertions.assertThat;

class PrioridadeCombinadaTest {

    private final PrioridadeCombinada politica = new PrioridadeCombinada();

    private Ocorrencia ocorrenciaComCategoriaEDias(Categoria categoria, int diasAtras) {
        return Ocorrencia.builder()
                .id(1L)
                .categoria(categoria)
                .descricao("Teste")
                .status(StatusOcorrencia.RECEBIDA)
                .localizacao(new Localizacao(-23.0, -46.0, null, "Centro"))
                .criadoEm(LocalDateTime.now().minusDays(diasAtras))
                .build();
    }

    @Test
    void calcula_aumentaComCategoriaCriticaETempoEmAberto() {
        Ocorrencia buraco5dias = ocorrenciaComCategoriaEDias(Categoria.BURACO, 5);
        Ocorrencia outro0dias = ocorrenciaComCategoriaEDias(Categoria.OUTRO, 0);
        Ocorrencia buraco0dias = ocorrenciaComCategoriaEDias(Categoria.BURACO, 0);

        int prioridadeBuraco5dias = politica.calcular(buraco5dias);
        int prioridadeOutro0dias = politica.calcular(outro0dias);
        int prioridadeBuraco0dias = politica.calcular(buraco0dias);

        // BURACO(5) + 5*2=10 = 15; OUTRO(1) + 0 = 1
        assertThat(prioridadeBuraco5dias).isGreaterThan(prioridadeOutro0dias);
        // Mais dias em aberto = mais prioridade
        assertThat(prioridadeBuraco5dias).isGreaterThan(prioridadeBuraco0dias);
        // Valores exatos
        assertThat(prioridadeBuraco5dias).isEqualTo(15);
        assertThat(prioridadeOutro0dias).isEqualTo(1);
    }
}
