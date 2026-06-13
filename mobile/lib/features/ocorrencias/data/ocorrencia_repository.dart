import 'package:dio/dio.dart';
import '../../../core/api/dio_client.dart';
import 'ocorrencia_mock.dart';
import 'ocorrencia_models.dart';

// Ativado via --dart-define=USE_MOCK_OCORRENCIAS=true (default dev)
const _useMock = bool.fromEnvironment('USE_MOCK_OCORRENCIAS', defaultValue: true);

class OcorrenciaRepository {
  OcorrenciaRepository._();
  static final OcorrenciaRepository instance = OcorrenciaRepository._();

  Dio get _dio => DioClient.instance.dio;

  Future<List<OcorrenciaListItem>> listarMinhas() async {
    if (_useMock) {
      await Future.delayed(const Duration(milliseconds: 600));
      return mockOcorrencias;
    }
    try {
      final res = await _dio.get('/api/ocorrencias/minhas');
      return (res.data as List<dynamic>)
          .map((e) => OcorrenciaListItem.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw DioClient.parseError(e);
    }
  }

  Future<OcorrenciaDetalhe> obterDetalhe(int id) async {
    if (_useMock) {
      await Future.delayed(const Duration(milliseconds: 400));
      return mockDetalhe(id);
    }
    try {
      final res = await _dio.get('/api/ocorrencias/$id');
      return OcorrenciaDetalhe.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw DioClient.parseError(e);
    }
  }

  Future<OcorrenciaCriadaDto> registrar(RegistrarOcorrenciaRequest req) async {
    if (_useMock) {
      await Future.delayed(const Duration(seconds: 1));
      return const OcorrenciaCriadaDto(id: 1285);
    }
    try {
      final res = await _dio.post('/api/ocorrencias', data: req.toJson());
      return OcorrenciaCriadaDto.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw DioClient.parseError(e);
    }
  }

  Future<void> avaliar(int ocorrenciaId, AvaliacaoRequest req) async {
    if (_useMock) {
      await Future.delayed(const Duration(milliseconds: 500));
      return;
    }
    try {
      await _dio.post('/api/ocorrencias/$ocorrenciaId/avaliacao', data: req.toJson());
    } on DioException catch (e) {
      throw DioClient.parseError(e);
    }
  }
}
