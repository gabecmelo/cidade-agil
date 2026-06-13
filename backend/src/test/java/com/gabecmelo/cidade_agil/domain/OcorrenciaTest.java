package com.gabecmelo.cidade_agil.domain;

import com.gabecmelo.cidade_agil.config.exception.TransicaoStatusInvalidaException;
import com.gabecmelo.cidade_agil.domain.enums.Categoria;
import com.gabecmelo.cidade_agil.domain.enums.StatusOcorrencia;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

class OcorrenciaTest {

    private Ocorrencia novaOcorrencia() {
        return Ocorrencia.builder()
                .categoria(Categoria.BURACO)
                .descricao("Buraco na rua")
                .localizacao(new Localizacao(-23.0, -46.0, null, "Centro"))
                .build();
    }

    @Test
    void transicaoStatus_aceitaSequenciaValida() {
        Ocorrencia o = novaOcorrencia();
        Usuario responsavel = Usuario.builder().id(1L).nome("Gestor").build();

        o.transicionarPara(StatusOcorrencia.EM_ANALISE, responsavel, null);
        assertThat(o.getStatus()).isEqualTo(StatusOcorrencia.EM_ANALISE);

        o.transicionarPara(StatusOcorrencia.EM_ATENDIMENTO, responsavel, null);
        assertThat(o.getStatus()).isEqualTo(StatusOcorrencia.EM_ATENDIMENTO);

        o.transicionarPara(StatusOcorrencia.RESOLVIDA, responsavel, null);
        assertThat(o.getStatus()).isEqualTo(StatusOcorrencia.RESOLVIDA);
    }

    @Test
    void transicaoStatus_rejeitaPulos() {
        Ocorrencia o = novaOcorrencia();
        Usuario responsavel = Usuario.builder().id(1L).nome("Gestor").build();

        assertThatThrownBy(() -> o.transicionarPara(StatusOcorrencia.RESOLVIDA, responsavel, null))
                .isInstanceOf(TransicaoStatusInvalidaException.class);

        assertThatThrownBy(() -> o.transicionarPara(StatusOcorrencia.EM_ATENDIMENTO, responsavel, null))
                .isInstanceOf(TransicaoStatusInvalidaException.class);
    }
}
