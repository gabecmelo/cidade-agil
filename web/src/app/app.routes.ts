import { Routes } from '@angular/router';
import { authGuard } from './core/auth/auth.guard';
import { roleGuard } from './core/auth/role.guard';

export const routes: Routes = [
  {
    path: 'login',
    loadComponent: () => import('./features/login/login.component').then((m) => m.LoginComponent),
  },
  {
    path: '',
    loadComponent: () => import('./features/shell/shell.component').then((m) => m.ShellComponent),
    canActivate: [authGuard, roleGuard],
    children: [
      {
        path: 'fila',
        loadComponent: () => import('./features/fila/fila.component').then((m) => m.FilaComponent),
      },
      { path: '', redirectTo: 'fila', pathMatch: 'full' },
    ],
  },
  { path: '**', redirectTo: 'fila' },
];
