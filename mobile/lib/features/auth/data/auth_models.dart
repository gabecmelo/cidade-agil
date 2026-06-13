class LoginRequestDto {
  const LoginRequestDto({required this.email, required this.senha});
  final String email;
  final String senha;
  Map<String, dynamic> toJson() => {'email': email, 'senha': senha};
}

class SignupRequestDto {
  const SignupRequestDto({required this.nome, required this.email, required this.senha});
  final String nome;
  final String email;
  final String senha;
  Map<String, dynamic> toJson() => {'nome': nome, 'email': email, 'senha': senha};
}

class AuthResponseDto {
  const AuthResponseDto({required this.token, required this.tipoUsuario});
  final String token;
  final String tipoUsuario;

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) =>
      AuthResponseDto(
        token: json['token'] as String,
        tipoUsuario: json['tipoUsuario'] as String,
      );
}

class MeResponseDto {
  const MeResponseDto({
    required this.id,
    required this.nome,
    required this.email,
    required this.tipo,
  });
  final int id;
  final String nome;
  final String email;
  final String tipo;

  factory MeResponseDto.fromJson(Map<String, dynamic> json) =>
      MeResponseDto(
        id: json['id'] as int,
        nome: json['nome'] as String,
        email: json['email'] as String,
        tipo: json['tipo'] as String,
      );
}
