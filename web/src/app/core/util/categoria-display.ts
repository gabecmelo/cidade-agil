import { Categoria } from '../models/enums';

const CATEGORIA_MAP: Record<Categoria, string> = {
  [Categoria.BURACO]: 'Buraco',
  [Categoria.ILUMINACAO]: 'Iluminação',
  [Categoria.CALCADA]: 'Calçada',
  [Categoria.ALAGAMENTO]: 'Alagamento',
  [Categoria.VANDALISMO]: 'Vandalismo',
  [Categoria.OUTRO]: 'Outro',
};

export function categoriaLabel(categoria: Categoria): string {
  return CATEGORIA_MAP[categoria] ?? categoria;
}
