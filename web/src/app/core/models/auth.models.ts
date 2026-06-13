import { TipoUsuario } from './enums';

export interface LoginPayload {
  email: string;
  senha: string;
}

export interface AuthResponse {
  token: string;
  tipoUsuario: TipoUsuario;
}

export interface MeResponse {
  id: number;
  nome: string;
  email: string;
  tipo: TipoUsuario;
}
