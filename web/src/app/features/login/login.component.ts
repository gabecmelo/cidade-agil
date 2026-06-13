import { Component, inject, signal } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { AuthService } from '../../core/auth/auth.service';

@Component({
  selector: 'app-login',
  imports: [ReactiveFormsModule],
  templateUrl: './login.component.html',
  styleUrl: './login.component.scss',
})
export class LoginComponent {
  private readonly fb = inject(FormBuilder);
  private readonly authService = inject(AuthService);
  private readonly router = inject(Router);

  readonly form = this.fb.nonNullable.group({
    email: ['', [Validators.required, Validators.email]],
    senha: ['', [Validators.required, Validators.minLength(6)]],
  });

  readonly isLoading = signal(false);
  readonly errorMsg = signal<string | null>(null);
  readonly showPassword = signal(false);

  onInput(): void {
    this.errorMsg.set(null);
  }

  onSubmit(): void {
    if (this.form.invalid || this.isLoading()) return;

    this.isLoading.set(true);
    this.errorMsg.set(null);

    const { email, senha } = this.form.getRawValue();
    this.authService.login({ email, senha }).subscribe({
      next: () => this.router.navigate(['/fila']),
      error: (err) => {
        this.isLoading.set(false);
        if (err?.message === 'Acesso negado a este painel.') {
          this.errorMsg.set('Acesso negado a este painel.');
        } else {
          const detail = err?.error?.detail;
          this.errorMsg.set(detail ?? 'Credenciais inválidas. Verifique e-mail e senha.');
        }
      },
    });
  }

  togglePassword(): void {
    this.showPassword.update((v) => !v);
  }
}
