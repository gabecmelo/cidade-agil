package com.gabecmelo.cidade_agil.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Embeddable
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Localizacao {

    @Column(name = "loc_latitude", nullable = false)
    private Double latitude;

    @Column(name = "loc_longitude", nullable = false)
    private Double longitude;

    @Column(name = "loc_endereco")
    private String enderecoFormatado;

    @Column(name = "loc_bairro")
    private String bairro;
}
