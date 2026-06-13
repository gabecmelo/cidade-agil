import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { OcorrenciaResumo, AtualizarStatusPayload } from '../models/ocorrencia.models';

@Injectable({ providedIn: 'root' })
export class ApiService {
  private readonly http = inject(HttpClient);

  listarFila(): Observable<OcorrenciaResumo[]> {
    return this.http.get<OcorrenciaResumo[]>('/api/ocorrencias');
  }

  atualizarStatus(id: number, payload: AtualizarStatusPayload): Observable<OcorrenciaResumo> {
    return this.http.patch<OcorrenciaResumo>(`/api/ocorrencias/${id}/status`, payload);
  }
}
