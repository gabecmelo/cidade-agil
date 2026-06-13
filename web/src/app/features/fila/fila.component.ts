import { Component, DestroyRef, computed, inject, signal } from '@angular/core';
import { takeUntilDestroyed } from '@angular/core/rxjs-interop';
import { FormsModule } from '@angular/forms';
import { interval, startWith, switchMap } from 'rxjs';
import { ApiService } from '../../core/api/api.service';
import { OcorrenciaResumo } from '../../core/models/ocorrencia.models';
import { StatusOcorrencia } from '../../core/models/enums';
import { statusDisplay } from '../../core/util/status-display';
import { categoriaLabel } from '../../core/util/categoria-display';
import { AtualizarStatusDialogComponent } from './atualizar-status.dialog.component';

const PAGE_SIZE = 10;
const POLL_INTERVAL_MS = 30_000;

@Component({
  selector: 'app-fila',
  imports: [FormsModule, AtualizarStatusDialogComponent],
  templateUrl: './fila.component.html',
  styleUrl: './fila.component.scss',
})
export class FilaComponent {
  private readonly api = inject(ApiService);
  private readonly destroyRef = inject(DestroyRef);

  readonly ocorrencias = signal<OcorrenciaResumo[]>([]);
  readonly isLoading = signal(true);
  readonly searchTerm = signal('');
  readonly currentPage = signal(0);
  readonly dialogOcorrencia = signal<OcorrenciaResumo | null>(null);

  readonly statusDisplay = statusDisplay;
  readonly categoriaLabel = categoriaLabel;

  /* KPIs */
  readonly kpiRecebidas = computed(
    () => this.ocorrencias().filter((o) => o.status === StatusOcorrencia.RECEBIDA).length,
  );
  readonly kpiAnalise = computed(
    () => this.ocorrencias().filter((o) => o.status === StatusOcorrencia.EM_ANALISE).length,
  );
  readonly kpiAtendimento = computed(
    () => this.ocorrencias().filter((o) => o.status === StatusOcorrencia.EM_ATENDIMENTO).length,
  );
  readonly kpiResolvidas = computed(
    () => this.ocorrencias().filter((o) => o.status === StatusOcorrencia.RESOLVIDA).length,
  );

  /* Filtered + paginated */
  readonly ocorrenciasFiltradas = computed(() => {
    const term = this.searchTerm().toLowerCase().trim();
    if (!term) return this.ocorrencias();
    return this.ocorrencias().filter(
      (o) =>
        `#${o.id}`.includes(term) ||
        (o.bairro ?? '').toLowerCase().includes(term) ||
        categoriaLabel(o.categoria).toLowerCase().includes(term),
    );
  });

  readonly totalPages = computed(() =>
    Math.max(1, Math.ceil(this.ocorrenciasFiltradas().length / PAGE_SIZE)),
  );

  readonly ocorrenciasPagina = computed(() => {
    const start = this.currentPage() * PAGE_SIZE;
    return this.ocorrenciasFiltradas().slice(start, start + PAGE_SIZE);
  });

  readonly paginaInfo = computed(() => {
    const total = this.ocorrenciasFiltradas().length;
    const start = this.currentPage() * PAGE_SIZE + 1;
    const end = Math.min(start + PAGE_SIZE - 1, total);
    return total === 0 ? 'Nenhuma ocorrência' : `Mostrando ${start}–${end} de ${total} ocorrências`;
  });

  readonly pageNumbers = computed(() =>
    Array.from({ length: this.totalPages() }, (_, i) => i),
  );

  readonly isResolvida = (status: StatusOcorrencia) => status === StatusOcorrencia.RESOLVIDA;

  constructor() {
    interval(POLL_INTERVAL_MS)
      .pipe(
        startWith(0),
        switchMap(() => this.api.listarFila()),
        takeUntilDestroyed(this.destroyRef),
      )
      .subscribe({
        next: (list) => {
          this.ocorrencias.set(list);
          this.isLoading.set(false);
        },
        error: () => this.isLoading.set(false),
      });
  }

  onSearch(term: string): void {
    this.searchTerm.set(term);
    this.currentPage.set(0);
  }

  goToPage(page: number): void {
    if (page >= 0 && page < this.totalPages()) {
      this.currentPage.set(page);
    }
  }

  openDialog(ocorrencia: OcorrenciaResumo): void {
    this.dialogOcorrencia.set(ocorrencia);
  }

  closeDialog(): void {
    this.dialogOcorrencia.set(null);
  }

  onStatusSaved(updated: OcorrenciaResumo): void {
    this.ocorrencias.update((list) =>
      list.map((o) => (o.id === updated.id ? updated : o)),
    );
    this.dialogOcorrencia.set(null);
  }

  priorityClass(prioridade: number): string {
    if (prioridade >= 80) return 'hi';
    if (prioridade >= 50) return 'md';
    return 'lo';
  }
}
