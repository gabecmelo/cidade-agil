package com.gabecmelo.cidade_agil.config.exception;

public class EmailEmUsoException extends RuntimeException {

    public EmailEmUsoException(String email) {
        super("E-mail já cadastrado: " + email);
    }
}
