import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from './auth.service';
import { TipoUsuario } from '../models/enums';

export const roleGuard: CanActivateFn = () => {
  const authService = inject(AuthService);
  const router = inject(Router);
  const user = authService.currentUser();

  if (user && user.tipo !== TipoUsuario.CIDADAO) {
    return true;
  }

  return router.createUrlTree(['/login']);
};
