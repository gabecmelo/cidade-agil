import { StatusOcorrencia } from '../models/enums';

/** Espelha StatusOcorrencia.podeTransicionarPara do backend. */
export function proximosStatusValidos(atual: StatusOcorrencia): StatusOcorrencia[] {
  switch (atual) {
    case StatusOcorrencia.RECEBIDA:
      return [StatusOcorrencia.EM_ANALISE];
    case StatusOcorrencia.EM_ANALISE:
      return [StatusOcorrencia.EM_ATENDIMENTO];
    case StatusOcorrencia.EM_ATENDIMENTO:
      return [StatusOcorrencia.RESOLVIDA];
    case StatusOcorrencia.RESOLVIDA:
      return [];
  }
}
