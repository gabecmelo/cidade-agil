import { Categoria, StatusOcorrencia } from './enums';

export interface OcorrenciaResumo {
  id: number;
  categoria: Categoria;
  status: StatusOcorrencia;
  descricao: string | null;
  prioridade: number;
  bairro: string | null;
  criadoEm: string;
}

export interface AtualizarStatusPayload {
  novoStatus: StatusOcorrencia;
  observacao: string | null;
}
