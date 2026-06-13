import { Component, inject, input, output, signal } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ApiService } from '../../core/api/api.service';
import { OcorrenciaResumo } from '../../core/models/ocorrencia.models';
import { StatusOcorrencia } from '../../core/models/enums';
import { statusDisplay } from '../../core/util/status-display';
import { proximosStatusValidos } from '../../core/util/transicoes-status';

@Component({
  selector: 'app-atualizar-status-dialog',
  imports: [FormsModule],
  templateUrl: './atualizar-status.dialog.component.html',
  styleUrl: './atualizar-status.dialog.component.scss',
})
export class AtualizarStatusDialogComponent {
  private readonly api = inject(ApiService);

  readonly ocorrencia = input.required<OcorrenciaResumo>();
  readonly fechar = output<void>();
  readonly salvo = output<OcorrenciaResumo>();

  readonly statusDisplay = statusDisplay;

  readonly novoStatus = signal<StatusOcorrencia | ''>('');
  readonly observacao = signal('');
  readonly isLoading = signal(false);
  readonly errorMsg = signal<string | null>(null);

  get proximosStatus(): StatusOcorrencia[] {
    return proximosStatusValidos(this.ocorrencia().status);
  }

  get podeSalvar(): boolean {
    return this.novoStatus() !== '' && !this.isLoading();
  }

  onBackdropClick(event: MouseEvent): void {
    if ((event.target as HTMLElement).classList.contains('modal-backdrop')) {
      this.fechar.emit();
    }
  }

  onEsc(event: KeyboardEvent): void {
    if (event.key === 'Escape') {
      this.fechar.emit();
    }
  }

  salvar(): void {
    const status = this.novoStatus();
    if (!status || this.isLoading()) return;

    this.isLoading.set(true);
    this.errorMsg.set(null);

    this.api
      .atualizarStatus(this.ocorrencia().id, {
        novoStatus: status,
        observacao: this.observacao().trim() || null,
      })
      .subscribe({
        next: (updated) => {
          this.isLoading.set(false);
          this.salvo.emit(updated);
        },
        error: (err) => {
          this.isLoading.set(false);
          const detail = err?.error?.detail;
          this.errorMsg.set(detail ?? 'Erro ao atualizar. Tente novamente.');
        },
      });
  }
}
