package com.gabecmelo.cidade_agil.repository;

import com.gabecmelo.cidade_agil.domain.Ocorrencia;
import org.springframework.data.jpa.repository.JpaRepository;

public interface OcorrenciaRepository extends JpaRepository<Ocorrencia, Long> {
}
