package com.gabecmelo.cidade_agil.config.exception;

public class OcorrenciaNaoEncontradaException extends RuntimeException {

    public OcorrenciaNaoEncontradaException(Long id) {
        super("Ocorrência não encontrada: id " + id);
    }
}
