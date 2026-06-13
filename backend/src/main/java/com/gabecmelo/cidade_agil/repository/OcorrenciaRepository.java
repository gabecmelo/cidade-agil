package com.gabecmelo.cidade_agil.repository;

import com.gabecmelo.cidade_agil.domain.Ocorrencia;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface OcorrenciaRepository extends JpaRepository<Ocorrencia, Long> {

    @EntityGraph(attributePaths = "criadoPor")
    List<Ocorrencia> findByCriadoPorIdOrderByCriadoEmDesc(Long usuarioId);

    @EntityGraph(attributePaths = "criadoPor")
    @Query("SELECT o FROM Ocorrencia o ORDER BY o.prioridade DESC, o.criadoEm DESC")
    List<Ocorrencia> findAllOrderByPrioridadeDesc();

    @EntityGraph(attributePaths = {"criadoPor", "historico", "historico.responsavel"})
    @Query("SELECT o FROM Ocorrencia o WHERE o.id = :id")
    Optional<Ocorrencia> findDetalheById(@Param("id") Long id);
}
