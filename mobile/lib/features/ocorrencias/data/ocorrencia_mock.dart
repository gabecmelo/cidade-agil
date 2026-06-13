import 'ocorrencia_models.dart';

// Dados estáticos para desenvolvimento enquanto CAG-004 não está disponível.
// Ativado via --dart-define=USE_MOCK_OCORRENCIAS=true
final mockOcorrencias = [
  OcorrenciaListItem(
    id: 1284,
    categoria: CategoriaDart.BURACO,
    status: StatusOcorrenciaDart.EM_ATENDIMENTO,
    criadoEm: DateTime.now().subtract(const Duration(hours: 2)),
    enderecoFormatado: 'Av. Brasil, 1240',
    locLatitude: -23.4200,
    locLongitude: -51.9300,
  ),
  OcorrenciaListItem(
    id: 1273,
    categoria: CategoriaDart.ILUMINACAO,
    status: StatusOcorrenciaDart.EM_ANALISE,
    criadoEm: DateTime.now().subtract(const Duration(days: 5)),
    enderecoFormatado: 'R. das Palmeiras, 87',
    locLatitude: -23.4210,
    locLongitude: -51.9310,
  ),
  OcorrenciaListItem(
    id: 1198,
    categoria: CategoriaDart.CALCADA,
    status: StatusOcorrenciaDart.RESOLVIDA,
    criadoEm: DateTime.now().subtract(const Duration(days: 8)),
    enderecoFormatado: 'R. XV de Novembro, 340',
    locLatitude: -23.4220,
    locLongitude: -51.9320,
  ),
  OcorrenciaListItem(
    id: 1140,
    categoria: CategoriaDart.ALAGAMENTO,
    status: StatusOcorrenciaDart.RECEBIDA,
    criadoEm: DateTime.now().subtract(const Duration(days: 12)),
    enderecoFormatado: 'Praça Central',
    locLatitude: -23.4230,
    locLongitude: -51.9330,
  ),
];

OcorrenciaDetalhe mockDetalhe(int id) {
  final now = DateTime.now();
  return OcorrenciaDetalhe(
    id: id,
    categoria: CategoriaDart.CALCADA,
    status: StatusOcorrenciaDart.RESOLVIDA,
    descricao:
        'Calçada quebrada com desnível de 15 cm, oferecendo risco a pedestres e cadeirantes. O problema está próximo ao ponto de ônibus.',
    criadoEm: now.subtract(const Duration(days: 8)),
    enderecoFormatado: 'R. XV de Novembro, 340',
    bairro: 'Centro',
    locLatitude: -23.4220,
    locLongitude: -51.9320,
    historico: [
      HistoricoEvento(
        para: StatusOcorrenciaDart.RECEBIDA,
        dataHora: now.subtract(const Duration(days: 8)),
      ),
      HistoricoEvento(
        para: StatusOcorrenciaDart.EM_ANALISE,
        dataHora: now.subtract(const Duration(days: 7)),
        observacao: 'Encaminhada para vistoria técnica.',
        responsavelNome: 'Gestor Marcelo',
      ),
      HistoricoEvento(
        para: StatusOcorrenciaDart.EM_ATENDIMENTO,
        dataHora: now.subtract(const Duration(days: 5)),
        observacao: 'Equipe deslocada ao local.',
        responsavelNome: 'Equipe Norte',
      ),
      HistoricoEvento(
        para: StatusOcorrenciaDart.RESOLVIDA,
        dataHora: now.subtract(const Duration(days: 3)),
        observacao: 'Calçada reparada. Aguardando avaliação.',
        responsavelNome: 'Equipe Norte',
      ),
    ],
    avaliacaoNota: null,
  );
}
