import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  AuthStorage._();
  static final AuthStorage instance = AuthStorage._();

  static const _keyToken = 'token';
  static const _keyTipo = 'tipo_usuario';

  final _storage = const FlutterSecureStorage();

  Future<String?> readToken() => _storage.read(key: _keyToken);
  Future<String?> readTipoUsuario() => _storage.read(key: _keyTipo);

  Future<void> save({required String token, required String tipoUsuario}) async {
    await _storage.write(key: _keyToken, value: token);
    await _storage.write(key: _keyTipo, value: tipoUsuario);
  }

  Future<void> clear() async {
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyTipo);
  }
}
