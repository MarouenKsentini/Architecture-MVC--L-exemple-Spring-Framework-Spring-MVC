import { Injectable, signal } from '@angular/core';
import { Product } from '../models/product.model';

/**
 * MODEL (couche données) — gère la liste des produits et expose un état observable.
 *
 * Ici les données sont en mémoire (pas d'appel HTTP), mais le composant (ViewModel)
 * ne connaît que cette API : il ne manipule jamais la liste directement.
 */
@Injectable({ providedIn: 'root' })
export class ProductService {
  private readonly _products = signal<Product[]>([
    { id: 1, libelle: 'Clavier', prix: 50.0, qteStock: 20 },
    { id: 2, libelle: 'Souris', prix: 25.0, qteStock: 40 },
  ]);

  /** État en lecture seule exposé au ViewModel. */
  readonly products = this._products.asReadonly();

  private nextId = 3;

  add(libelle: string, prix: number, qteStock: number): void {
    this._products.update((list) => [
      ...list,
      { id: this.nextId++, libelle, prix, qteStock },
    ]);
  }

  remove(id: number): void {
    this._products.update((list) => list.filter((p) => p.id !== id));
  }

  findById(id: number): Product | undefined {
    return this._products().find((p) => p.id === id);
  }
}
