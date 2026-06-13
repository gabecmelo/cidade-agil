package com.gabecmelo.cidade_agil.repository;

import com.gabecmelo.cidade_agil.domain.Avaliacao;
import org.springframework.data.jpa.repository.JpaRepository;

public interface AvaliacaoRepository extends JpaRepository<Avaliacao, Long> {
}
