# test-api.ps1 — smoke-test the 5 REST CRUD operations of ProduitRestController.
# Uses real curl.exe, NOT the PowerShell 'curl' alias (which maps to
# Invoke-WebRequest and rejects -H/-d). Request bodies come from
# new-produit.json / update-produit.json in this folder.
#
# Prereq: the app is running (runapp.bat / start-app.ps1) on http://localhost:8080
# Usage : powershell -ExecutionPolicy Bypass -File .\test-api.ps1

$ErrorActionPreference = "Stop"
$dir  = $PSScriptRoot
$base = "http://localhost:8080/api/produits"

function Show($label, $text) {
    Write-Host "`n===== $label =====" -ForegroundColor Cyan
    Write-Host $text
}

# Fail fast with a clear message if the server is not up.
try   { Invoke-WebRequest $base -UseBasicParsing -TimeoutSec 5 | Out-Null }
catch { Write-Host "Serveur injoignable sur $base - lancez d'abord runapp.bat" -ForegroundColor Red; exit 1 }

# 1) AJOUTER un produit (POST) -> 201 + JSON with generated id
$created = curl.exe -s -w "`nHTTP %{http_code}" -X POST $base `
    -H "Content-Type: application/json" -d "@$dir\new-produit.json"
Show "1) POST $base  (ajouter)" $created
$id = ($created -split "`n")[0] | ConvertFrom-Json | Select-Object -ExpandProperty id
Write-Host "--> id cree = $id" -ForegroundColor Yellow

# 2) RECUPERER tous les produits (GET) -> 200
Show "2) GET $base  (tous)" (curl.exe -s -w "`nHTTP %{http_code}" $base)

# 3) RECUPERER un produit par son id (GET /{id}) -> 200
Show "3) GET $base/$id" (curl.exe -s -w "`nHTTP %{http_code}" "$base/$id")

# 4) METTRE A JOUR un produit (PUT /{id}) -> 200 with merged fields
Show "4) PUT $base/$id" (curl.exe -s -w "`nHTTP %{http_code}" -X PUT "$base/$id" `
    -H "Content-Type: application/json" -d "@$dir\update-produit.json")

# 5) SUPPRIMER un produit (DELETE /{id}) -> 204
Show "5) DELETE $base/$id" (curl.exe -s -o NUL -w "HTTP %{http_code}" -X DELETE "$base/$id")

# 6) Verifier la suppression (GET /{id}) -> 404
Show "6) GET $base/$id  (404 attendu)" (curl.exe -s -o NUL -w "HTTP %{http_code}" "$base/$id")

Write-Host "`nOK - les 5 operations ont ete executees." -ForegroundColor Green
