import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

// ASCII puro — bate com o enum Java do backend
enum CategoriaDart { BURACO, ILUMINACAO, CALCADA, ALAGAMENTO, VANDALISMO, OUTRO }

extension CategoriaDartExt on CategoriaDart {
  String get label => switch (this) {
        CategoriaDart.BURACO => 'Buraco',
        CategoriaDart.ILUMINACAO => 'Iluminação',
        CategoriaDart.CALCADA => 'Calçada',
        CategoriaDart.ALAGAMENTO => 'Alagamento',
        CategoriaDart.VANDALISMO => 'Vandalismo',
        CategoriaDart.OUTRO => 'Outro',
      };

  IconData get icon => switch (this) {
        CategoriaDart.BURACO => Symbols.dangerous,
        CategoriaDart.ILUMINACAO => Symbols.lightbulb,
        CategoriaDart.CALCADA => Symbols.directions_walk,
        CategoriaDart.ALAGAMENTO => Symbols.water_drop,
        CategoriaDart.VANDALISMO => Symbols.format_paint,
        CategoriaDart.OUTRO => Symbols.more_horiz,
      };

  static CategoriaDart fromJson(String value) =>
      CategoriaDart.values.firstWhere((e) => e.name == value);
}

enum StatusOcorrenciaDart { RECEBIDA, EM_ANALISE, EM_ATENDIMENTO, RESOLVIDA }

extension StatusOcorrenciaDartExt on StatusOcorrenciaDart {
  String get label => switch (this) {
        StatusOcorrenciaDart.RECEBIDA => 'Recebida',
        StatusOcorrenciaDart.EM_ANALISE => 'Em análise',
        StatusOcorrenciaDart.EM_ATENDIMENTO => 'Em atendimento',
        StatusOcorrenciaDart.RESOLVIDA => 'Resolvida',
      };

  static StatusOcorrenciaDart fromJson(String value) =>
      StatusOcorrenciaDart.values.firstWhere((e) => e.name == value);
}

class HistoricoEvento {
  const HistoricoEvento({
    required this.para,
    required this.dataHora,
    this.observacao,
    this.responsavelNome,
  });

  final StatusOcorrenciaDart para;
  final DateTime dataHora;
  final String? observacao;
  final String? responsavelNome;

  factory HistoricoEvento.fromJson(Map<String, dynamic> json) =>
      HistoricoEvento(
        para: StatusOcorrenciaDartExt.fromJson(json['para'] as String),
        dataHora: DateTime.parse(json['dataHora'] as String),
        observacao: json['observacao'] as String?,
        responsavelNome: json['responsavelNome'] as String?,
      );
}

class OcorrenciaListItem {
  const OcorrenciaListItem({
    required this.id,
    required this.categoria,
    required this.status,
    required this.criadoEm,
    this.enderecoFormatado,
    this.bairro,
    this.locLatitude,
    this.locLongitude,
    this.fotoPequena,
  });

  final int id;
  final CategoriaDart categoria;
  final StatusOcorrenciaDart status;
  final DateTime criadoEm;
  final String? enderecoFormatado;
  final String? bairro;
  final double? locLatitude;
  final double? locLongitude;
  final String? fotoPequena;

  // Endereço com fallback: enderecoFormatado → bairro → lat,long
  String get enderecoDisplay {
    if (enderecoFormatado != null && enderecoFormatado!.isNotEmpty) return enderecoFormatado!;
    if (bairro != null && bairro!.isNotEmpty) return bairro!;
    if (locLatitude != null && locLongitude != null) {
      return '${locLatitude!.toStringAsFixed(4)}, ${locLongitude!.toStringAsFixed(4)}';
    }
    return '';
  }

  factory OcorrenciaListItem.fromJson(Map<String, dynamic> json) =>
      OcorrenciaListItem(
        id: json['id'] as int,
        categoria: CategoriaDartExt.fromJson(json['categoria'] as String),
        status: StatusOcorrenciaDartExt.fromJson(json['status'] as String),
        criadoEm: DateTime.parse(json['criadoEm'] as String),
        enderecoFormatado: json['enderecoFormatado'] as String?,
        bairro: json['bairro'] as String?,
        locLatitude: (json['locLatitude'] as num?)?.toDouble(),
        locLongitude: (json['locLongitude'] as num?)?.toDouble(),
        fotoPequena: json['fotoPequena'] as String?,
      );
}

class OcorrenciaDetalhe {
  const OcorrenciaDetalhe({
    required this.id,
    required this.categoria,
    required this.status,
    required this.descricao,
    required this.criadoEm,
    required this.historico,
    this.enderecoFormatado,
    this.bairro,
    this.locLatitude,
    this.locLongitude,
    this.fotoBase64,
    this.avaliacaoNota,
  });

  final int id;
  final CategoriaDart categoria;
  final StatusOcorrenciaDart status;
  final String descricao;
  final DateTime criadoEm;
  final List<HistoricoEvento> historico;
  final String? enderecoFormatado;
  final String? bairro;
  final double? locLatitude;
  final double? locLongitude;
  final String? fotoBase64;
  final int? avaliacaoNota;

  bool get podeAvaliar =>
      status == StatusOcorrenciaDart.RESOLVIDA && avaliacaoNota == null;

  String get enderecoDisplay {
    if (enderecoFormatado != null && enderecoFormatado!.isNotEmpty) return enderecoFormatado!;
    if (bairro != null && bairro!.isNotEmpty) return bairro!;
    if (locLatitude != null && locLongitude != null) {
      return '${locLatitude!.toStringAsFixed(4)}, ${locLongitude!.toStringAsFixed(4)}';
    }
    return '';
  }

  factory OcorrenciaDetalhe.fromJson(Map<String, dynamic> json) =>
      OcorrenciaDetalhe(
        id: json['id'] as int,
        categoria: CategoriaDartExt.fromJson(json['categoria'] as String),
        status: StatusOcorrenciaDartExt.fromJson(json['status'] as String),
        descricao: json['descricao'] as String,
        criadoEm: DateTime.parse(json['criadoEm'] as String),
        historico: (json['historico'] as List<dynamic>)
            .map((e) => HistoricoEvento.fromJson(e as Map<String, dynamic>))
            .toList(),
        enderecoFormatado: json['enderecoFormatado'] as String?,
        bairro: json['bairro'] as String?,
        locLatitude: (json['locLatitude'] as num?)?.toDouble(),
        locLongitude: (json['locLongitude'] as num?)?.toDouble(),
        fotoBase64: json['fotoBase64'] as String?,
        avaliacaoNota: json['avaliacaoNota'] as int?,
      );
}

class RegistrarOcorrenciaRequest {
  const RegistrarOcorrenciaRequest({
    required this.categoria,
    required this.descricao,
    required this.fotoBase64,
    required this.latitude,
    required this.longitude,
    this.enderecoFormatado,
    this.bairro,
  });

  final CategoriaDart categoria;
  final String descricao;
  final String fotoBase64;
  final double latitude;
  final double longitude;
  final String? enderecoFormatado;
  final String? bairro;

  Map<String, dynamic> toJson() => {
        'categoria': categoria.name,
        'descricao': descricao,
        'fotoBase64': fotoBase64,
        'latitude': latitude,
        'longitude': longitude,
        if (enderecoFormatado != null) 'enderecoFormatado': enderecoFormatado,
        if (bairro != null) 'bairro': bairro,
      };
}

class AvaliacaoRequest {
  const AvaliacaoRequest({required this.nota, this.comentario});
  final int nota;
  final String? comentario;
  Map<String, dynamic> toJson() => {
        'nota': nota,
        if (comentario != null && comentario!.isNotEmpty) 'comentario': comentario,
      };
}

// Resposta da criação de ocorrência
class OcorrenciaCriadaDto {
  const OcorrenciaCriadaDto({required this.id});
  final int id;
  factory OcorrenciaCriadaDto.fromJson(Map<String, dynamic> json) =>
      OcorrenciaCriadaDto(id: json['id'] as int);
}
