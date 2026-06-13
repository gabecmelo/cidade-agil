import 'package:dio/dio.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/storage/auth_storage.dart';
import 'auth_models.dart';

class AuthRepository {
  AuthRepository._();
  static final AuthRepository instance = AuthRepository._();

  Dio get _dio => DioClient.instance.dio;

  Future<void> signup(SignupRequestDto req) async {
    try {
      await _dio.post('/api/auth/signup', data: req.toJson());
    } on DioException catch (e) {
      throw DioClient.parseError(e);
    }
  }

  Future<AuthResponseDto> login(LoginRequestDto req) async {
    try {
      final res = await _dio.post('/api/auth/login', data: req.toJson());
      return AuthResponseDto.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw DioClient.parseError(e);
    }
  }

  Future<MeResponseDto> me() async {
    try {
      final res = await _dio.get('/api/auth/me');
      return MeResponseDto.fromJson(res.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw DioClient.parseError(e);
    }
  }

  Future<void> logout() => AuthStorage.instance.clear();
}
