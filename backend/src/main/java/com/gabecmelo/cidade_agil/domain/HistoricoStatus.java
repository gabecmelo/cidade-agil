package com.gabecmelo.cidade_agil.domain;

import com.gabecmelo.cidade_agil.domain.enums.StatusOcorrencia;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "historico_status")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class HistoricoStatus {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ocorrencia_id", nullable = false)
    private Ocorrencia ocorrencia;

    @Enumerated(EnumType.STRING)
    @Column(length = 30)
    private StatusOcorrencia de;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 30)
    private StatusOcorrencia para;

    @Column(columnDefinition = "TEXT")
    private String observacao;

    @Column(name = "data_hora", nullable = false)
    @Builder.Default
    private LocalDateTime dataHora = LocalDateTime.now();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "responsavel_id")
    private Usuario responsavel;
}
