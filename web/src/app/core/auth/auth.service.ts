import { Injectable, computed, inject, signal } from '@angular/core';
import { Router } from '@angular/router';
import { HttpClient } from '@angular/common/http';
import { Observable, tap, switchMap } from 'rxjs';
import { AuthResponse, LoginPayload, MeResponse } from '../models/auth.models';
import { TipoUsuario } from '../models/enums';

const TOKEN_KEY = 'cidadeagil_token';

@Injectable({ providedIn: 'root' })
export class AuthService {
  private readonly http = inject(HttpClient);
  private readonly router = inject(Router);

  private readonly _currentUser = signal<MeResponse | null>(null);
  readonly currentUser = this._currentUser.asReadonly();
  readonly isAuthenticated = computed(() => this._currentUser() !== null);

  getToken(): string | null {
    return localStorage.getItem(TOKEN_KEY);
  }

  login(payload: LoginPayload): Observable<MeResponse> {
    return this.http.post<AuthResponse>('/api/auth/login', payload).pipe(
      tap((res) => {
        if (res.tipoUsuario === TipoUsuario.CIDADAO) {
          throw new Error('Acesso negado a este painel.');
        }
        localStorage.setItem(TOKEN_KEY, res.token);
      }),
      switchMap(() => this.http.get<MeResponse>('/api/auth/me')),
      tap((me) => this._currentUser.set(me)),
    );
  }

  logout(): void {
    localStorage.removeItem(TOKEN_KEY);
    this._currentUser.set(null);
    this.router.navigate(['/login']);
  }

  /** Restaura sessão na inicialização se existir token armazenado. */
  restoreSession(): Observable<MeResponse> {
    return this.http.get<MeResponse>('/api/auth/me').pipe(
      tap((me) => this._currentUser.set(me)),
    );
  }
}
