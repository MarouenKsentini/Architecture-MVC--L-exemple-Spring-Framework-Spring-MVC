import { TestBed } from '@angular/core/testing';
import { ProductList } from './product-list';

describe('ProductList (MVVM)', () => {
  beforeEach(async () => {
    await TestBed.configureTestingModule({ imports: [ProductList] }).compileComponents();
  });

  it('affiche les produits venant du service (Model)', async () => {
    const fixture = TestBed.createComponent(ProductList);
    await fixture.whenStable();
    const text = (fixture.nativeElement as HTMLElement).textContent ?? '';
    expect(text).toContain('Clavier');
    expect(text).toContain('Souris');
  });

  it("ajoute un produit via l'action du ViewModel", async () => {
    const fixture = TestBed.createComponent(ProductList);
    const vm = fixture.componentInstance;
    vm.libelle = 'Ecran';
    vm.prix = 199.99;
    vm.qteStock = 5;
    vm.add();
    await fixture.whenStable();
    const text = (fixture.nativeElement as HTMLElement).textContent ?? '';
    expect(text).toContain('Ecran');
  });

  it('supprime un produit', async () => {
    const fixture = TestBed.createComponent(ProductList);
    const vm = fixture.componentInstance;
    const id = vm.products()[0].id;
    vm.remove(id);
    await fixture.whenStable();
    expect(vm.products().find((p) => p.id === id)).toBeUndefined();
  });
});
