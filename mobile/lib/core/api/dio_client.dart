import 'package:dio/dio.dart';
import '../storage/auth_storage.dart';
import 'api_errors.dart';

// Callback registrado pelo router ao subir o app
typedef OnUnauthorized = void Function();

class DioClient {
  DioClient._({required this.dio});

  static DioClient? _instance;
  late OnUnauthorized? _onUnauthorized;

  static DioClient get instance {
    assert(_instance != null, 'DioClient.init() must be called first');
    return _instance!;
  }

  final Dio dio;

  static void init({OnUnauthorized? onUnauthorized}) {
    const baseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://10.0.2.2:8080');
    final d = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ));

    final client = DioClient._(dio: d);
    client._onUnauthorized = onUnauthorized;
    client._setupInterceptors();
    _instance = client;
  }

  void registerOnUnauthorized(OnUnauthorized callback) {
    _onUnauthorized = callback;
  }

  void _setupInterceptors() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await AuthStorage.instance.readToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await AuthStorage.instance.clear();
          _onUnauthorized?.call();
        }
        return handler.next(error);
      },
    ));
  }

  // Converte DioException em AppError
  static AppError parseError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      return AppError.fromProblemDetail(data);
    }
    return AppError.unknown();
  }
}
