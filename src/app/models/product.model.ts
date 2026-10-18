/**
 * MODEL — L'entité métier « Produit ».
 * Miroir du Produit de l'atelier Spring MVC : id, libelle, prix, qteStock.
 */
export interface Product {
  id: number;
  libelle: string;
  prix: number;
  qteStock: number;
}
