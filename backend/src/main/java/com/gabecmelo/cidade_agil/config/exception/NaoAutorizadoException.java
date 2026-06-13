package com.gabecmelo.cidade_agil.config.exception;

public class NaoAutorizadoException extends RuntimeException {

    public NaoAutorizadoException() {
        super("Você não tem permissão para executar esta operação.");
    }
}
