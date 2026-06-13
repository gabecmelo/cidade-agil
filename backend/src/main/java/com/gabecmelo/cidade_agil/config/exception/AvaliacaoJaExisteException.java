package com.gabecmelo.cidade_agil.config.exception;

public class AvaliacaoJaExisteException extends RuntimeException {

    public AvaliacaoJaExisteException(Long ocorrenciaId) {
        super("Esta ocorrência já possui avaliação: id " + ocorrenciaId);
    }
}
