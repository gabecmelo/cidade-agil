import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/ocorrencia_models.dart';
import '../data/ocorrencia_repository.dart';

class OcorrenciasListNotifier extends AsyncNotifier<List<OcorrenciaListItem>> {
  @override
  Future<List<OcorrenciaListItem>> build() =>
      OcorrenciaRepository.instance.listarMinhas();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(OcorrenciaRepository.instance.listarMinhas);
  }
}

final ocorrenciasListProvider =
    AsyncNotifierProvider<OcorrenciasListNotifier, List<OcorrenciaListItem>>(
  OcorrenciasListNotifier.new,
);

final ocorrenciaDetalheProvider =
    FutureProvider.family<OcorrenciaDetalhe, int>((ref, id) {
  return OcorrenciaRepository.instance.obterDetalhe(id);
});
