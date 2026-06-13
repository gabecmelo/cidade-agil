package com.gabecmelo.cidade_agil.repository;

import com.gabecmelo.cidade_agil.domain.Avaliacao;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface AvaliacaoRepository extends JpaRepository<Avaliacao, Long> {

    boolean existsByOcorrenciaId(Long ocorrenciaId);

    Optional<Avaliacao> findByOcorrenciaId(Long ocorrenciaId);
}
