# Architecture MVC — L'exemple Spring Framework / Spring MVC

Projet d'atelier illustrant l'**architecture MVC** (Modèle – Vue – Contrôleur) avec le **Spring Framework / Spring MVC**, appliqué à la gestion de produits (`Produit`).

L'application expose à la fois :

- une **API REST** (JSON) pour le CRUD complet sur les produits ;
- une **vue Thymeleaf** (page HTML) pour lister et ajouter des produits depuis le navigateur.

---

## 🧱 Technologies

| Élément | Version / Détail |
|---|---|
| Java | 17 |
| Spring Boot | 4.1.1 (Spring MVC, Spring Data JPA) |
| Maven | 3.9.x |
| Base de données | H2 **en mémoire** (`jdbc:h2:mem:testdb`) |
| Vue | Thymeleaf + Bootstrap 4.5.2 (CDN) |
| Port | **8080** |

---

## 🏗️ Architecture (MVC en couches)

```
org.iset.productapp
├── ProductappApplication        # Point d'entrée Spring Boot
├── model/       Produit          # M — entité JPA (id, libelle, prix, qteStock)
├── repository/  ProduitRepository# Accès données (JpaRepository)
├── service/     ProduitService   # Logique métier (délégation au repository)
├── controller/  ProduitRestController  # C — API REST  (/api/produits)
│               ProduitController       # C — Vues Thymeleaf (/produits)
└── templates/   produits.html    # V — vue HTML
```

- **Modèle** : `Produit` (`id`, `libelle`, `prix`, `qteStock`), `id` généré automatiquement.
- **Vue** : page Thymeleaf `produits.html` (tableau + formulaire d'ajout).
- **Contrôleur** : `ProduitRestController` (JSON) et `ProduitController` (HTML).

---

## 🔌 API REST

Base : `http://localhost:8080/api/produits`

| Méthode | Chemin | Description | Succès | Échec |
|---|---|---|---|---|
| `GET` | `/api/produits` | Récupérer tous les produits | 200 | — |
| `GET` | `/api/produits/{id}` | Récupérer un produit par son id | 200 | 404 |
| `POST` | `/api/produits` | Ajouter un nouveau produit | 201 | 400 |
| `PUT` | `/api/produits/{id}` | Mettre à jour un produit selon un id | 200 | 404 |
| `DELETE` | `/api/produits/{id}` | Supprimer un produit selon un id | 204 | 404 |

Format JSON d'un produit :

```json
{ "id": 1, "libelle": "Clavier", "prix": 50.0, "qteStock": 20 }
```

> `id` est généré à la création : ne pas l'envoyer dans un `POST`.

---

## ▶️ Lancer l'application

### Prérequis
- JDK 17 (`JAVA_HOME` défini)
- Maven 3.9.x

### Avec le wrapper Maven
```bash
./mvnw spring-boot:run
```

### Avec Maven installé
```bash
mvn spring-boot:run
```

Puis ouvrir :
- Vue HTML : <http://localhost:8080/produits>
- API JSON : <http://localhost:8080/api/produits>
- Console H2 : <http://localhost:8080/h2-console> (JDBC URL `jdbc:h2:mem:testdb`, user `marouen`, mot de passe vide)

---

## 🧪 Tester l'API avec curl

```bash
# 1) Ajouter un nouveau produit (POST)
curl -X POST http://localhost:8080/api/produits \
  -H "Content-Type: application/json" \
  -d '{"libelle":"Produit Test", "prix": 100.0, "qteStock": 10}'

# 2) Récupérer tous les produits (GET)
curl http://localhost:8080/api/produits

# 3) Récupérer un produit par son ID (GET)
curl http://localhost:8080/api/produits/1

# 4) Mettre à jour un produit selon un id (PUT)
curl -X PUT http://localhost:8080/api/produits/1 \
  -H "Content-Type: application/json" \
  -d '{"libelle":"Produit Modifie", "prix": 150.0, "qteStock": 5}'

# 5) Supprimer un produit selon un id (DELETE)
curl -X DELETE http://localhost:8080/api/produits/1
```

> Sous **Windows PowerShell**, utiliser `curl.exe` (l'alias `curl` = `Invoke-WebRequest` ne comprend pas `-H`/`-d`).
> Deux scripts prêts à l'emploi sont fournis : `test-api.ps1` (PowerShell) et `test-api.sh` (Git Bash).

---

## ⚠️ Remarques

- La base H2 est **en mémoire** : les données sont perdues à chaque redémarrage.
- Le chemin est **`/api/produits`** (français), pas `/api/products`.
