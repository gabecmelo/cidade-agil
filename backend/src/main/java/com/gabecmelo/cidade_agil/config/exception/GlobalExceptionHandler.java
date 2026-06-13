package com.gabecmelo.cidade_agil.config.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.List;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(EmailEmUsoException.class)
    public ProblemDetail handleEmailEmUso(EmailEmUsoException ex) {
        ProblemDetail pd = ProblemDetail.forStatusAndDetail(HttpStatus.CONFLICT, ex.getMessage());
        pd.setProperty("codigo", "email_em_uso");
        return pd;
    }

    @ExceptionHandler(CredenciaisInvalidasException.class)
    public ProblemDetail handleCredenciaisInvalidas(CredenciaisInvalidasException ex) {
        ProblemDetail pd = ProblemDetail.forStatusAndDetail(HttpStatus.UNAUTHORIZED, ex.getMessage());
        pd.setProperty("codigo", "credenciais_invalidas");
        return pd;
    }

    @ExceptionHandler(OcorrenciaNaoEncontradaException.class)
    public ProblemDetail handleOcorrenciaNaoEncontrada(OcorrenciaNaoEncontradaException ex) {
        ProblemDetail pd = ProblemDetail.forStatusAndDetail(HttpStatus.NOT_FOUND, ex.getMessage());
        pd.setProperty("codigo", "ocorrencia_nao_encontrada");
        return pd;
    }

    @ExceptionHandler(TransicaoStatusInvalidaException.class)
    public ProblemDetail handleTransicaoStatusInvalida(TransicaoStatusInvalidaException ex) {
        ProblemDetail pd = ProblemDetail.forStatusAndDetail(HttpStatus.UNPROCESSABLE_ENTITY, ex.getMessage());
        pd.setProperty("codigo", "transicao_status_invalida");
        return pd;
    }

    @ExceptionHandler(AvaliacaoAntesResolucaoException.class)
    public ProblemDetail handleAvaliacaoAntesResolucao(AvaliacaoAntesResolucaoException ex) {
        ProblemDetail pd = ProblemDetail.forStatusAndDetail(HttpStatus.UNPROCESSABLE_ENTITY, ex.getMessage());
        pd.setProperty("codigo", "avaliacao_antes_resolucao");
        return pd;
    }

    @ExceptionHandler(AvaliacaoJaExisteException.class)
    public ProblemDetail handleAvaliacaoJaExiste(AvaliacaoJaExisteException ex) {
        ProblemDetail pd = ProblemDetail.forStatusAndDetail(HttpStatus.CONFLICT, ex.getMessage());
        pd.setProperty("codigo", "avaliacao_ja_existe");
        return pd;
    }

    @ExceptionHandler(FotoMuitoGrandeException.class)
    public ProblemDetail handleFotoMuitoGrande(FotoMuitoGrandeException ex) {
        ProblemDetail pd = ProblemDetail.forStatusAndDetail(HttpStatus.PAYLOAD_TOO_LARGE, ex.getMessage());
        pd.setProperty("codigo", "foto_muito_grande");
        return pd;
    }

    @ExceptionHandler(NaoAutorizadoException.class)
    public ProblemDetail handleNaoAutorizado(NaoAutorizadoException ex) {
        ProblemDetail pd = ProblemDetail.forStatusAndDetail(HttpStatus.FORBIDDEN, ex.getMessage());
        pd.setProperty("codigo", "nao_autorizado");
        return pd;
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ProblemDetail handleValidacao(MethodArgumentNotValidException ex) {
        List<String> erros = ex.getBindingResult().getFieldErrors().stream()
                .map(e -> e.getField() + ": " + e.getDefaultMessage())
                .toList();
        ProblemDetail pd = ProblemDetail.forStatusAndDetail(HttpStatus.BAD_REQUEST, "Dados inválidos na requisição.");
        pd.setProperty("codigo", "validacao_falhou");
        pd.setProperty("erros", erros);
        return pd;
    }
}
