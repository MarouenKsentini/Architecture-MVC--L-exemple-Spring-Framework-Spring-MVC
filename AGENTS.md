# AGENTS.md — productapp

Spring Boot 4.1.1 / Java 17 / Maven + H2 in-memory + JPA, WebMVC, Thymeleaf. Single module, no CI, no lint/format plugins.

## Build & run (Windows — this machine)

The Maven wrapper does **not** work here: `mvnw.cmd` is `only-script` and tries to download Maven 3.9.16 from `repo.maven.apache.org`, which is blocked. Use the local Maven 3.9.14 and set `JAVA_HOME` first (the default env points at a non-existent JDK 26):

```
set "JAVA_HOME=C:\Program Files\Java\jdk-17.0.18"
"C:\apache-maven\apache-maven-3.9.14\bin\mvn.cmd" spring-boot:run -f pom.xml
```

- Shortcuts that do exactly this: `runapp.bat` (appends to `mvn-run.log`) and `start-app.ps1` (logs to `mvn-stdout.log` / `mvn-stderr.log`).
- Smoke-test all five CRUD endpoints: `powershell -ExecutionPolicy Bypass -File .\test-api.ps1` (PowerShell) or `bash test-api.sh` (Git Bash). Both require the app running on 8080 and use the JSON body files. Bare `bash` on PATH is WSL; Git Bash is at `C:\Program Files\Git\bin\bash.exe`.
- Tests: same `mvn.cmd` with `test`. Single test: `mvn.cmd -Dtest=ProductappApplicationTests test` — the only test is an empty `contextLoads`, so it proves context bootstrapping only. Prefer `@WebMvcTest` / `@DataJpaTest` when adding real tests.
- **App port is 8080** (`server.port=8080`; a clean run logs `Tomcat started on port 8080`). If you get "port 8080 was already in use", it is almost always a **previous instance of this same app** still running — check `Get-NetTCPConnection -State Listen -LocalPort 8080`, then `Stop-Process -Id <pid>`. An older `mvn-stdout.log` showing 8081 is historical; don't chase it. H2 console: `/h2-console`.

## Wiring

- Entrypoint: `src/main/java/org/iset/productapp/ProductappApplication.java`.
- `controller/ProduitRestController.java` — REST CRUD at `/api/produits` (`GET` all, `GET /{id}`, `POST`, `PUT /{id}`, `DELETE /{id}`; PUT merges only `libelle/prix/qteStock`).
- `controller/ProduitController.java` — Thymeleaf MVC at `GET /produits` (renders `produits.html`) and `POST /produits/add` (redirects to `/produits`). Both are wired and working (MVC POST → 302, row visible via REST).
- `service/ProduitService.java` — thin delegate over the repository; `findById` returns `null` (not `Optional`) for missing entities and controllers map that to 404.
- `repository/ProduitRepository.java` — `JpaRepository<Produit, Long>`.
- `model/Produit.java` — `id, libelle, prix (Double), qteStock (Integer)`; `id` is `IDENTITY`-generated.
- Template: `src/main/resources/templates/produits.html` (Bootstrap 4.5.2 CDN). `static/` is empty.
- Dependencies use **Spring Boot 4 artifact names**, not the classic ones: `spring-boot-starter-webmvc` (not `-web`), `spring-boot-h2console`, and `-test` starters (`spring-boot-starter-webmvc-test`, `-data-jpa-test`, `-thymeleaf-test`). Copy the naming in `pom.xml` when adding deps.

## Gotchas

- **The path is French: `/api/produits`.** `/api/products` (English) returns a Whitelabel 404 — this is the most common request mistake. Same for the MVC page: `/produits`.
- **curl in PowerShell:** bare `curl` is an alias for `Invoke-WebRequest`, which rejects `-H`/`-d` and `\` line-continuations (it wants `-ContentType`/`-Body`, and `` ` `` for continuation). Call **`curl.exe`** instead. Passing JSON from a file (`-d "@new-produit.json"`) works in every shell; inline `-d '{...}'` happens to work in PowerShell but breaks under `cmd.exe`. Sample bodies: `new-produit.json`, `update-produit.json`; captured request/response transcripts in `curl-results/`.
- **H2 is ephemeral:** no `ddl-auto`, no `data.sql`. Schema is created by Hibernate, DB is empty on every restart (`jdbc:h2:mem:testdb`, user `marouen`, empty password). Do not rely on persisted state.
- DI style is field `@Autowired`, not constructor injection — match the surrounding code.
- `spring.jpa.database-platform=org.hibernate.dialect.H2Dialect` is set explicitly even though Hibernate warns it is unnecessary.
- `.github/` has no CI — only Copilot modernization hook scripts under `.github/modernize/java-upgrade` (its contents are git-ignored).
- The parent `C:\Users\marou\AGENTS.md` is auto-loaded too, but three of its claims are stale: the wrapper is **unusable** (see above); the `produits.html` form is **not** dead (`ProduitController` handles it); and the port is **8080 in the current config**, not 8081 (see above).
