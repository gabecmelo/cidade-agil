package com.gabecmelo.cidade_agil.config.exception;

public class AvaliacaoAntesResolucaoException extends RuntimeException {

    public AvaliacaoAntesResolucaoException() {
        super("Avaliação só pode ser enviada após a ocorrência ser resolvida.");
    }
}
