import { inject } from '@angular/core';
import { CanActivateFn, Router } from '@angular/router';
import { AuthService } from './auth.service';
import { catchError, map, of } from 'rxjs';

export const authGuard: CanActivateFn = () => {
  const authService = inject(AuthService);
  const router = inject(Router);

  if (authService.isAuthenticated()) {
    return true;
  }

  const token = authService.getToken();
  if (!token) {
    return router.createUrlTree(['/login']);
  }

  return authService.restoreSession().pipe(
    map(() => true),
    catchError(() => of(router.createUrlTree(['/login']))),
  );
};
