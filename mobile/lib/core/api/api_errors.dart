class AppError implements Exception {
  const AppError({required this.code, required this.message});

  final String code;
  final String message;

  factory AppError.fromProblemDetail(Map<String, dynamic> json) {
    return AppError(
      code: (json['codigo'] as String?) ?? 'erro_desconhecido',
      message: (json['detail'] as String?) ?? 'Ocorreu um erro inesperado.',
    );
  }

  factory AppError.unknown() =>
      const AppError(code: 'erro_desconhecido', message: 'Ocorreu um erro inesperado.');

  @override
  String toString() => 'AppError($code): $message';
}
