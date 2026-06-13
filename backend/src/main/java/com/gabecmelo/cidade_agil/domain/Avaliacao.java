package com.gabecmelo.cidade_agil.domain;

import com.gabecmelo.cidade_agil.config.exception.AvaliacaoAntesResolucaoException;
import com.gabecmelo.cidade_agil.domain.enums.StatusOcorrencia;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "avaliacao")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Avaliacao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ocorrencia_id", nullable = false, unique = true)
    private Ocorrencia ocorrencia;

    @Column(nullable = false)
    private Short nota;

    @Column(columnDefinition = "TEXT")
    private String comentario;

    @Column(name = "criado_em", nullable = false)
    @Builder.Default
    private LocalDateTime criadoEm = LocalDateTime.now();

    public static Avaliacao criar(Ocorrencia ocorrencia, Short nota, String comentario) {
        if (nota < 1 || nota > 5) {
            throw new IllegalArgumentException("Nota deve estar entre 1 e 5.");
        }
        if (ocorrencia.getStatus() != StatusOcorrencia.RESOLVIDA) {
            throw new AvaliacaoAntesResolucaoException();
        }
        return Avaliacao.builder()
                .ocorrencia(ocorrencia)
                .nota(nota)
                .comentario(comentario)
                .build();
    }
}
