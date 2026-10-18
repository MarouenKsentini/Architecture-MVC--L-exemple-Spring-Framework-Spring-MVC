#!/usr/bin/env bash
# test-api.sh — test de l'API ProduitRestController avec curl (syntaxe "bash" du sujet).
# A executer sous Git Bash / WSL / Linux (pas PowerShell).
# Prerequis : l'application tourne sur http://localhost:8080 (runapp.bat / mvn spring-boot:run).
#
# Usage : bash test-api.sh

set -e
BASE="http://localhost:8080/api/produits"

echo "=== 1) AJOUTER un nouveau produit (POST /api/produits) ==="
CREATED=$(curl -s -w '\nHTTP %{http_code}' -X POST "$BASE" \
  -H "Content-Type: application/json" \
  -d '{"libelle":"Produit Test", "prix": 100.0, "qteStock": 10}')
echo "$CREATED"
ID=$(echo "$CREATED" | head -1 | sed -E 's/.*"id":([0-9]+).*/\1/')
echo "--> id genere = $ID"

echo
echo "=== 2) RECUPERER tous les produits (GET /api/produits) ==="
curl -s -w '\nHTTP %{http_code}\n' "$BASE"

echo
echo "=== 3) RECUPERER un produit par son ID (GET /api/produits/$ID) ==="
curl -s -w '\nHTTP %{http_code}\n' "$BASE/$ID"

echo
echo "=== 4) METTRE A JOUR un produit selon un id (PUT /api/produits/$ID) ==="
curl -s -w '\nHTTP %{http_code}\n' -X PUT "$BASE/$ID" \
  -H "Content-Type: application/json" \
  -d '{"libelle":"Produit Modifie", "prix": 150.0, "qteStock": 5}'

echo
echo "=== 5) SUPPRIMER un produit selon un id (DELETE /api/produits/$ID) ==="
curl -s -o /dev/null -w 'HTTP %{http_code}\n' -X DELETE "$BASE/$ID"

echo
echo "=== Verif : le produit supprime n'existe plus (GET /api/produits/$ID) ==="
curl -s -o /dev/null -w 'HTTP %{http_code}\n' "$BASE/$ID"
