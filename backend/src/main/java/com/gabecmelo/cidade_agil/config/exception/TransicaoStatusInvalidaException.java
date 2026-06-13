package com.gabecmelo.cidade_agil.config.exception;

import com.gabecmelo.cidade_agil.domain.enums.StatusOcorrencia;

public class TransicaoStatusInvalidaException extends RuntimeException {

    public TransicaoStatusInvalidaException(StatusOcorrencia de, StatusOcorrencia para) {
        super("Transição de status inválida: " + de + " → " + para);
    }
}
