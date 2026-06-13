package com.gabecmelo.cidade_agil.domain.enums;

public enum StatusOcorrencia {
    RECEBIDA,
    EM_ANALISE,
    EM_ATENDIMENTO,
    RESOLVIDA;

    public boolean podeTransicionarPara(StatusOcorrencia novo) {
        return switch (this) {
            case RECEBIDA      -> novo == EM_ANALISE;
            case EM_ANALISE    -> novo == EM_ATENDIMENTO;
            case EM_ATENDIMENTO -> novo == RESOLVIDA;
            case RESOLVIDA     -> false;
        };
    }
}
