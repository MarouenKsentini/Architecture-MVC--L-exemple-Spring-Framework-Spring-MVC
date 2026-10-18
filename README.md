# TP2 — MVVM Angular 

Atelier **TP2** : mise en œuvre de l'**architecture MVVM** (_Model – View – ViewModel_) avec **Angular**.

Même domaine que l'atelier Spring MVC : la gestion de **produits** (`id`, `libelle`, `prix`, `qteStock`).

## Correspondance MVVM

| Couche | Fichier | Rôle |
|---|---|---|
| **Model** | `src/app/models/product.model.ts` | L'entité `Product` (les données) |
| **Model** | `src/app/services/product.service.ts` | Couche données : état (`signal`), `add`, `remove`, `findById` |
| **ViewModel** | `src/app/components/product-list/product-list.ts` | Expose l'état (`products`, `total`) et les actions (`add`, `remove`) |
| **View** | `src/app/components/product-list/product-list.html` | Template : affiche l'état, délègue les clics au ViewModel |

Le composant (ViewModel) ne manipule jamais la liste directement : il passe toujours par le service (Model). La vue ne contient aucune logique.

## Démarrer

```bash
npm install      # (déjà fait à la génération)
npm start        # -> http://localhost:4200
```

## Tester

```bash
npm test         # tests unitaires (Vitest + jsdom)
npm run build    # build de production
```

Tests inclus (`app.spec.ts`, `product-list.spec.ts`) : création du composant, affichage des produits, ajout, suppression.

## Stack

- Angular 22 (composants **standalone**, **signals**)
- RxJS 7
- TypeScript 6
- Tests : **Vitest** + jsdom
