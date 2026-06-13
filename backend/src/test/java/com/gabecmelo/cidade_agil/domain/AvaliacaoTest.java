package com.gabecmelo.cidade_agil.domain;

import com.gabecmelo.cidade_agil.config.exception.AvaliacaoAntesResolucaoException;
import com.gabecmelo.cidade_agil.domain.enums.Categoria;
import com.gabecmelo.cidade_agil.domain.enums.StatusOcorrencia;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

class AvaliacaoTest {

    private Ocorrencia ocorrenciaResolvida() {
        return Ocorrencia.builder()
                .id(1L)
                .categoria(Categoria.BURACO)
                .descricao("Buraco resolvido")
                .status(StatusOcorrencia.RESOLVIDA)
                .localizacao(new Localizacao(-23.0, -46.0, null, "Centro"))
                .build();
    }

    private Ocorrencia ocorrenciaAberta() {
        return Ocorrencia.builder()
                .id(2L)
                .categoria(Categoria.BURACO)
                .descricao("Buraco em aberto")
                .status(StatusOcorrencia.EM_ANALISE)
                .localizacao(new Localizacao(-23.0, -46.0, null, "Centro"))
                .build();
    }

    @Test
    void criar_rejeitaNotaForaDaFaixa() {
        Ocorrencia o = ocorrenciaResolvida();

        assertThatThrownBy(() -> Avaliacao.criar(o, (short) 0, null))
                .isInstanceOf(IllegalArgumentException.class);

        assertThatThrownBy(() -> Avaliacao.criar(o, (short) 6, null))
                .isInstanceOf(IllegalArgumentException.class);
    }

    @Test
    void criar_rejeitaQuandoStatusNaoEhResolvida() {
        Ocorrencia o = ocorrenciaAberta();

        assertThatThrownBy(() -> Avaliacao.criar(o, (short) 5, "Ótimo"))
                .isInstanceOf(AvaliacaoAntesResolucaoException.class);
    }

    @Test
    void criar_notaValida_retornaAvaliacao() {
        Ocorrencia o = ocorrenciaResolvida();

        Avaliacao a = Avaliacao.criar(o, (short) 4, "Bom atendimento");

        assertThat(a.getNota()).isEqualTo((short) 4);
        assertThat(a.getOcorrencia()).isEqualTo(o);
    }
}
