package com.gabecmelo.cidade_agil.config.exception;

public class FotoMuitoGrandeException extends RuntimeException {

    public FotoMuitoGrandeException() {
        super("A foto enviada ultrapassa o limite de 5 MB.");
    }
}
