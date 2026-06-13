import { StatusOcorrencia } from '../models/enums';

export interface StatusDisplay {
  label: string;
  icon: string;
  cssClass: string;
}

const STATUS_MAP: Record<StatusOcorrencia, StatusDisplay> = {
  [StatusOcorrencia.RECEBIDA]: {
    label: 'Recebida',
    icon: 'mark_email_unread',
    cssClass: 'badge-recebida',
  },
  [StatusOcorrencia.EM_ANALISE]: {
    label: 'Em análise',
    icon: 'search',
    cssClass: 'badge-em_analise',
  },
  [StatusOcorrencia.EM_ATENDIMENTO]: {
    label: 'Em atendimento',
    icon: 'construction',
    cssClass: 'badge-em_atendimento',
  },
  [StatusOcorrencia.RESOLVIDA]: {
    label: 'Resolvida',
    icon: 'task_alt',
    cssClass: 'badge-resolvida',
  },
};

export function statusDisplay(status: StatusOcorrencia): StatusDisplay {
  return STATUS_MAP[status];
}
