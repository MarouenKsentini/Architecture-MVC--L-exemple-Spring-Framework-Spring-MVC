import { CurrencyPipe } from '@angular/common';
import { Component, computed, inject } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ProductService } from '../../services/product.service';

/**
 * VIEWMODEL — expose à la vue un état et des actions.
 * Le composant ne contient PAS de logique de données : elle est déléguée au service (Model).
 */
@Component({
  selector: 'app-product-list',
  imports: [FormsModule, CurrencyPipe],
  templateUrl: './product-list.html',
  styleUrl: './product-list.css',
})
export class ProductList {
  private readonly productService = inject(ProductService);

  // ---- État exposé à la View ----
  readonly products = this.productService.products;
  readonly total = computed(() =>
    this.products().reduce((sum, p) => sum + p.prix * p.qteStock, 0),
  );

  // Champs liés au formulaire (two-way binding)
  libelle = '';
  prix = 0;
  qteStock = 0;

  // ---- Actions ----
  add(): void {
    if (!this.libelle.trim()) {
      return;
    }
    this.productService.add(this.libelle.trim(), this.prix, this.qteStock);
    this.libelle = '';
    this.prix = 0;
    this.qteStock = 0;
  }

  remove(id: number): void {
    this.productService.remove(id);
  }
}
