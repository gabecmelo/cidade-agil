package com.gabecmelo.cidade_agil.controller;

import com.gabecmelo.cidade_agil.controller.dto.*;
import com.gabecmelo.cidade_agil.service.OcorrenciaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/ocorrencias")
@RequiredArgsConstructor
public class OcorrenciaController {

    private final OcorrenciaService ocorrenciaService;

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    @PreAuthorize("hasRole('CIDADAO')")
    public OcorrenciaResumoResponse criar(
            @Valid @RequestBody CriarOcorrenciaRequest request,
            @AuthenticationPrincipal UserDetails userDetails) {
        return ocorrenciaService.criar(request, userDetails.getUsername());
    }

    @GetMapping("/minhas")
    @PreAuthorize("hasRole('CIDADAO')")
    public List<OcorrenciaResumoResponse> listarMinhas(
            @AuthenticationPrincipal UserDetails userDetails) {
        return ocorrenciaService.listarMinhas(userDetails.getUsername());
    }

    @GetMapping
    @PreAuthorize("hasRole('GESTOR') or hasRole('TECNICO')")
    public List<OcorrenciaResumoResponse> listarFila() {
        return ocorrenciaService.listarFila();
    }

    @GetMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public OcorrenciaDetalheResponse detalhe(@PathVariable Long id) {
        return ocorrenciaService.detalhe(id);
    }

    @PatchMapping("/{id}/status")
    @PreAuthorize("hasRole('GESTOR') or hasRole('TECNICO')")
    public OcorrenciaResumoResponse atualizarStatus(
            @PathVariable Long id,
            @Valid @RequestBody AtualizarStatusRequest request,
            @AuthenticationPrincipal UserDetails userDetails) {
        return ocorrenciaService.atualizarStatus(id, request, userDetails.getUsername());
    }

    @PostMapping("/{id}/avaliacao")
    @ResponseStatus(HttpStatus.CREATED)
    @PreAuthorize("hasRole('CIDADAO')")
    public AvaliacaoResponse avaliar(
            @PathVariable Long id,
            @Valid @RequestBody CriarAvaliacaoRequest request,
            @AuthenticationPrincipal UserDetails userDetails) {
        return ocorrenciaService.avaliar(id, request, userDetails.getUsername());
    }
}
