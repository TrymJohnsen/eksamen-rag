#!/usr/bin/env bash
# =============================================================================
# create-issues.sh – Opprett alle backlog-issues i GitHub
#
# Bruk:
#   gh auth login                                          # logg inn én gang
#   ./scripts/create-issues.sh TrymJohnsen/eksamen-rag    # opprett alle issues
#
# Krever: GitHub CLI (https://cli.github.com)
# =============================================================================
set -euo pipefail

REPO="${1:-}"
if [[ -z "$REPO" ]]; then
  echo "Bruk: $0 EIER/REPO"
  echo "Eks:  $0 TrymJohnsen/eksamen-rag"
  exit 1
fi

issue() {
  local title="$1" body="$2" labels="$3"
  echo "Oppretter: $title"
  # Bygg --label-flagg
  local flags=()
  IFS=',' read -ra arr <<< "$labels"
  for l in "${arr[@]}"; do flags+=(--label "${l// /}"); done
  gh issue create --repo "$REPO" --title "$title" --body "$body" "${flags[@]}"
}

label() {
  gh label create "$1" --color "$2" --description "$3" --repo "$REPO" 2>/dev/null \
    || gh label edit "$1" --color "$2" --description "$3" --repo "$REPO" 2>/dev/null \
    || true
}

# --- Labels ---
echo "==> Oppretter labels..."
label "bug"           "d73a4a" "Noe fungerer ikke"
label "enhancement"   "a2eeef" "Ny funksjon eller forbedring"
label "documentation" "0075ca" "Dokumentasjon"
label "infra"         "5319e7" "Infrastruktur og deployment"
label "docker"        "0db7ed" "Docker og containerisering"
label "shell"         "ff9800" "Shell scripts og automatisering"
label "linux"         "795548" "Linux og OS"
label "python"        "3572A5" "Python"
label "api"           "1d76db" "API-endepunkter"
label "ingestion"     "f9d0c4" "Dokument-ingestion"
label "embeddings"    "bfd4f2" "Embeddings"
label "ai"            "d4c5f9" "AI-komponenter"
label "search"        "fef2c0" "Søk"
label "config"        "f0e68c" "Konfigurasjon"
label "logging"       "b60205" "Logging"
label "healthcheck"   "006b75" "Helsesjekk"
label "observability" "0e8a16" "Observability"
label "ci"            "2cbe4e" "Continuous Integration"
label "security"      "b60205" "Sikkerhet"
label "kubernetes"    "326ce5" "Kubernetes"
label "nginx"         "009900" "Nginx"

# --- Epic 1 ---
echo "==> Epic 1 – Prosjektstruktur"
issue "[E1-1] Bytt requirements.txt med pyproject.toml" \
"Erstatt \`requirements.txt\` med en moderne \`pyproject.toml\` som definerer avhengigheter og Python-versjon.

**Oppgaver**
- [ ] Opprett \`pyproject.toml\` med \`[project]\`-seksjon
- [ ] Flytt avhengigheter fra \`requirements.txt\`
- [ ] Legg til dev-avhengigheter (pytest, ruff, httpx)
- [ ] Oppdater README med ny installasjonsinstruksjon

**Akseptansekriterier**
- \`pip install -e \".[dev]\"\` fungerer uten feil" \
"enhancement,python"

issue "[E1-2] Skriv en skikkelig README" \
"Skriv en README som forklarer prosjektet, arkitektur, lokal kjøring og Docker-kjøring.

**Oppgaver**
- [ ] Legg til prosjektbeskrivelse og mål
- [ ] Dokumenter alle API-endepunkter med curl-eksempel
- [ ] Legg til Quick Start (lokalt og Docker)
- [ ] Legg til seksjoner: Prerequisites, Miljøvariabler, Prosjektstruktur

**Akseptansekriterier**
- En ny utvikler kan kjøre prosjektet kun ved å følge README" \
"documentation"

issue "[E1-3] Legg til CONTRIBUTING.md" \
"Dokumenter branch-navngiving, commit-konvensjoner og PR-prosess.

**Oppgaver**
- [ ] Opprett \`CONTRIBUTING.md\`
- [ ] Beskriv branch-navngiving (feature/, fix/, infra/)
- [ ] Beskriv commit-message-konvensjon (Conventional Commits)
- [ ] Dokumenter lokal dev-setup" \
"documentation"

issue "[E1-4] Sett opp ruff for linting og .editorconfig" \
"Legg til \`.editorconfig\` og ruff-konfigurasjon slik at kodebasen følger konsistent stil.

**Oppgaver**
- [ ] Opprett \`.editorconfig\`
- [ ] Legg til \`[tool.ruff]\` i \`pyproject.toml\`
- [ ] Kjør \`ruff format .\` og fiks eksisterende feil

**Akseptansekriterier**
- \`ruff check .\` passerer uten feil" \
"python"

# --- Epic 2 ---
echo "==> Epic 2 – Dokument-ingestion"
issue "[E2-1] 🐛 Fiks syntaksfeil og fullfør ingest_documents()" \
"**Kritisk bugfix.** \`ingest_documents()\` i \`app/services/ingestion.py\` har en syntaksfeil på linje 40 og mangler implementasjon.

**Oppgaver**
- [ ] Fiks løs variabel \`f\` på linje 40
- [ ] Fullfør loop som samler chunks fra alle dokumenter
- [ ] Returner liste med \`{filename, chunk_index, content}\` per chunk
- [ ] Legg til feilhåndtering for filer som ikke kan leses
- [ ] Skriv unit test

**Akseptansekriterier**
- \`ingest_documents()\` kjøres uten feil og returnerer chunks" \
"bug,ingestion,python"

issue "[E2-2] Støtt .txt, .md og .pdf filer" \
"Utvid \`load_documents()\` til å lese .txt, .md og .pdf (via pypdf).

**Oppgaver**
- [ ] Legg til pypdf i avhengigheter
- [ ] Implementer filtype-basert ruting i \`load_documents()\`
- [ ] Logg og hopp over ukjente filformater

**Akseptansekriterier**
- Alle tre filtyper leses korrekt" \
"enhancement,ingestion,python"

issue "[E2-3] Konfigurerbar chunk-størrelse og overlapp" \
"Forbedre \`chunk_text()\` med overlapp mellom chunks og konfigurasjon via env-variabler.

**Oppgaver**
- [ ] Legg til \`chunk_overlap\`-parameter
- [ ] Legg til \`CHUNK_SIZE\` og \`CHUNK_OVERLAP\` i \`Settings\`
- [ ] Oppdater \`.env.example\`

**Akseptansekriterier**
- Chunk-størrelse og overlapp er konfigurerbar via env" \
"enhancement,ingestion,config"

issue "[E2-4] Legg til POST /ingest API-endepunkt" \
"Legg til et endepunkt som trigger ingestion og returnerer statistikk.

**Oppgaver**
- [ ] Legg til \`POST /ingest\` i routes
- [ ] Returner \`{status, files_processed, chunks_created, duration_ms}\`
- [ ] Logg start og slutt med tidsmåling" \
"enhancement,ingestion,api"

issue "[E2-5] Idempotent ingestion (hopp over uendrede filer)" \
"Unngå re-ingesting av dokumenter som ikke har endret seg.

**Oppgaver**
- [ ] Lagre MD5-hash per fil i JSON-fil
- [ ] Sjekk hash ved re-ingesting
- [ ] Legg til \`force=true\`-parameter for full re-ingestion" \
"enhancement,ingestion"

# --- Epic 3 ---
echo "==> Epic 3 – Embeddings og vektorlagring"
issue "[E3-1] Integrer sentence-transformers for lokale embeddings" \
"Integrer sentence-transformers for å lage lokale vektorrepresentasjoner.

**Oppgaver**
- [ ] Legg til \`sentence-transformers\` i avhengigheter
- [ ] Opprett \`app/services/embeddings.py\`
- [ ] Implementer \`get_embedding(text) -> list[float]\`
- [ ] Legg til \`EMBEDDING_MODEL\` i Settings (default: all-MiniLM-L6-v2)
- [ ] Lazy loading av modell (last ved første kall)" \
"enhancement,embeddings,ai"

issue "[E3-2] Sett opp FAISS som lokal vektordatabase" \
"Integrer FAISS for lagring og søk i embeddings.

**Oppgaver**
- [ ] Legg til \`faiss-cpu\` i avhengigheter
- [ ] Opprett \`app/services/vector_store.py\`
- [ ] Implementer \`VectorStore\` med \`add()\` og \`search()\`
- [ ] Lagre metadata (filename, chunk_index) parallelt" \
"enhancement,ai"

issue "[E3-3] Koble ingestion → embedding → FAISS i én pipeline" \
"Koble alle komponenter til en sammenhengende indekseringspipeline.

**Oppgaver**
- [ ] Opprett \`app/services/indexer.py\`
- [ ] Implementer \`build_index()\`
- [ ] Integrer med POST /ingest
- [ ] Logg fremdrift og total tid" \
"enhancement,ingestion,embeddings,ai"

issue "[E3-4] Lagre og last FAISS-indeksen fra disk" \
"Sørg for at indeksen overlever container-restart.

**Oppgaver**
- [ ] Implementer \`save_index()\` og \`load_index()\`
- [ ] Bruk \`INDEX_PATH\` fra Settings
- [ ] Last indeks automatisk ved oppstart
- [ ] Håndter korrupt indeksfil med logg-advarsel" \
"enhancement,ai"

issue "[E3-5] Legg til GET /index/status endepunkt" \
"Returner status for FAISS-indeksen: antall vektorer, modell, sist oppdatert.

**Oppgaver**
- [ ] Legg til \`GET /index/status\` i routes
- [ ] Returner \`{vector_count, embedding_model, last_indexed}\`
- [ ] Returner 204 om indeks ikke er bygget" \
"enhancement,api,observability"

# --- Epic 4 ---
echo "==> Epic 4 – Søk og query-API"
issue "[E4-1] Implementer semantisk søk med FAISS" \
"Implementer faktisk semantisk søk i \`run_query()\`.

**Oppgaver**
- [ ] Kall \`get_embedding()\` på query-teksten
- [ ] Søk i FAISS med query-embedding
- [ ] Returner topp-k chunks med metadata og score
- [ ] Legg til \`k\`-parameter (default: 5)" \
"enhancement,search,ai"

issue "[E4-2] Validering og feilhåndtering på /query" \
"Robust validering med tydelige HTTP-feilmeldinger.

**Oppgaver**
- [ ] Returner 503 om indeks ikke er bygget
- [ ] Legg til MAX_QUERY_LENGTH i config
- [ ] Returner 500 med logg ved uventet feil" \
"enhancement,api"

issue "[E4-3] Resultatrangering og kontekstvindu" \
"Returner resultater sortert etter score, med naboer-chunks som kontekst.

**Oppgaver**
- [ ] Sorter etter cosine similarity (høyeste først)
- [ ] Legg til \`include_context=true\`-parameter" \
"enhancement,search,ai"

issue "[E4-4] Legg til POST /query for lange søk" \
"Støtt lange queries via POST med JSON-body.

**Oppgaver**
- [ ] Opprett Pydantic-modell QueryRequest
- [ ] Legg til \`POST /query\` med QueryRequest-body" \
"enhancement,api"

# --- Epic 5 ---
echo "==> Epic 5 – Konfigurasjon"
issue "[E5-1] Migrer til Pydantic BaseSettings" \
"Bytt ut enkel Settings-klasse med Pydantic BaseSettings for automatisk type-validering.

**Oppgaver**
- [ ] Legg til \`pydantic-settings\` i avhengigheter
- [ ] Migrer \`app/core/config.py\` til BaseSettings
- [ ] Legg til type-validering for alle felt
- [ ] Valider APP_ENV (development / staging / production)" \
"enhancement,config,python"

issue "[E5-2] Dokumenter alle miljøvariabler i .env.example" \
"Oppdater .env.example med alle variabler og beskrivende kommentarer.

**Oppgaver**
- [ ] List alle variabler med kommentarer
- [ ] Legg til nye variabler (CHUNK_SIZE, EMBEDDING_MODEL, etc.)
- [ ] Skill mellom required og optional" \
"documentation,config"

issue "[E5-3] Valider kritisk konfigurasjon ved oppstart" \
"Sjekk at DOCUMENTS_PATH og INDEX_PATH er tilgjengelige ved oppstart.

**Oppgaver**
- [ ] Legg til startup-event i main.py
- [ ] Logg alle konfigurasjoner ved oppstart (maskér secrets)" \
"enhancement,config"

issue "[E5-4] Produksjonsmodus med strengere innstillinger" \
"APP_ENV=production aktiverer JSON-logging og slår av debug-modus.

**Oppgaver**
- [ ] Bruk APP_ENV til å sette log-nivå
- [ ] Slå av FastAPI debug i prod
- [ ] Dokumenter forskjellen i README" \
"enhancement,config"

# --- Epic 6 ---
echo "==> Epic 6 – Logging og feilhåndtering"
issue "[E6-1] Strukturert JSON-logging i produksjon" \
"Konfigurer logging til å outputte JSON i produksjon (Loki/ELK-kompatibelt).

**Oppgaver**
- [ ] Legg til \`python-json-logger\` i avhengigheter
- [ ] Opprett \`app/core/logging_config.py\`
- [ ] JSON i prod, tekst i dev (basert på APP_ENV)" \
"enhancement,logging"

issue "[E6-2] Request/response logging middleware" \
"Logg alle innkommende forespørsler og utgående svar.

**Oppgaver**
- [ ] Opprett \`app/api/middleware.py\`
- [ ] Logg: method, path, status_code, duration_ms
- [ ] 5xx-feil logges på ERROR-nivå" \
"enhancement,logging,api"

issue "[E6-3] Global exception handler" \
"Fang uventede feil og returner konsistente JSON-feilresponser.

**Oppgaver**
- [ ] Legg til global exception handler i main.py
- [ ] Returner {error: Internal server error} i prod
- [ ] Logg alle unhandled exceptions med stack trace" \
"enhancement,api,security"

issue "[E6-4] Correlation ID på alle forespørsler" \
"Generer X-Request-ID per kall og inkluder i alle logg-meldinger.

**Oppgaver**
- [ ] Generer UUID per request i middleware
- [ ] Legg til i logg-meldinger og response headers" \
"enhancement,logging,observability"

issue "[E6-5] Logg-rotasjon til fil" \
"Skriv logger til fil med automatisk rotasjon.

**Oppgaver**
- [ ] Legg til RotatingFileHandler
- [ ] Lagre i logs/ (allerede i .gitignore)
- [ ] Konfigurerbar maks filstørrelse og antall backups" \
"enhancement,logging"

# --- Epic 7 ---
echo "==> Epic 7 – Healthcheck og observability"
issue "[E7-1] Utvid /health med systemsjekker" \
"Rapporter disk, indeks-tilstand og embedding-modell i /health.

**Oppgaver**
- [ ] Sjekk at DOCUMENTS_PATH er tilgjengelig
- [ ] Rapporter om indeks er lastet og antall vektorer
- [ ] Rapporter tilgjengelig diskplass
- [ ] Returner 503 om kritisk feil" \
"enhancement,healthcheck,observability"

issue "[E7-2] Legg til /ready readiness probe" \
"Returner 200 kun når appen er fullt klar til å betjene requests.

**Oppgaver**
- [ ] Legg til /ready endepunkt
- [ ] Returner 503 mens appen starter opp
- [ ] Dokumenter forskjellen på /health og /ready" \
"enhancement,healthcheck,kubernetes"

issue "[E7-3] Legg til uptime og diskplass i health-respons" \
"Legg til operasjonell metadata: uptime, diskbruk, PID, versjon.

**Oppgaver**
- [ ] Legg til uptime_seconds, disk_free_gb, pid, version" \
"enhancement,healthcheck,observability"

issue "[E7-4] Enkelt /metrics endepunkt" \
"Enkel statistikk: antall requests, indekserte dokumenter og queries.

**Oppgaver**
- [ ] Tell requests siden oppstart per endepunkt
- [ ] Returner {total_requests, documents_indexed, queries_served}" \
"enhancement,observability"

# --- Epic 8 ---
echo "==> Epic 8 – Docker"
issue "[E8-1] Lag Dockerfile med multi-stage build" \
"Skriv Dockerfile med multi-stage build for et minimalt produksjonsimage.

**Oppgaver**
- [ ] To stages: builder og runtime
- [ ] Base: python:3.11-slim
- [ ] Kjør som non-root user (appuser)
- [ ] Legg til HEALTHCHECK-instruksjon" \
"enhancement,docker,infra"

issue "[E8-2] Lag .dockerignore" \
"Hold Docker build context liten.

**Oppgaver**
- [ ] Ekskluder .git, .venv, __pycache__, logs/, indexes/, .env" \
"enhancement,docker"

issue "[E8-3] Lag docker-compose.yml" \
"Start hele applikasjonen med ett kommando.

**Oppgaver**
- [ ] Definer app-service med build og port-mapping
- [ ] Les env fra .env-fil
- [ ] Legg til restart: unless-stopped
- [ ] Dokumenter i README" \
"enhancement,docker,infra"

issue "[E8-4] Konfigurerbar volum-mount for dokumenter og indekser" \
"Dokumenter og indekser skal overleve container-restart.

**Oppgaver**
- [ ] Bind-mount ./documents og ./indexes i docker-compose.yml
- [ ] Dokumenter hvordan man legger til dokumenter uten rebuild" \
"enhancement,docker,infra"

issue "[E8-5] Dokumenter alle Docker miljøvariabler" \
"Lag tabell i README: Variabel | Default | Beskrivelse.

**Oppgaver**
- [ ] Legg til environment-seksjon i docker-compose.yml
- [ ] Lag tabell i README" \
"documentation,docker,config"

# --- Epic 9 ---
echo "==> Epic 9 – Shell scripts"
issue "[E9-1] Lag start.sh og stop.sh" \
"Scripts for å starte og stoppe appen (lokal og Docker-modus).

**Oppgaver**
- [ ] start.sh med --docker flagg
- [ ] stop.sh som stopper pent
- [ ] set -euo pipefail og usage-hjelpetekst i begge" \
"enhancement,shell,linux"

issue "[E9-2] Lag setup.sh for å sette opp utviklingsmiljøet" \
"Bootstrap-script som setter opp alt fra bunnen av.

**Oppgaver**
- [ ] Sjekk Python-versjon (krev 3.10+)
- [ ] Opprett .venv og installer avhengigheter
- [ ] Kopier .env.example → .env om .env mangler
- [ ] Opprett documents/ og indexes/ mapper
- [ ] Idempotent: trygt å kjøre flere ganger" \
"enhancement,shell,linux"

issue "[E9-3] Lag ingest.sh for å trigge ingestion via API" \
"Shell-script som sender POST /ingest og viser statistikk.

**Oppgaver**
- [ ] Send POST /ingest via curl
- [ ] Vis responsstatistikk i terminalen
- [ ] Støtt --host og --port argumenter" \
"enhancement,shell"

issue "[E9-4] Lag healthcheck.sh som returnerer exit code" \
"Script for Docker og systemd healthcheck.

**Oppgaver**
- [ ] Send GET /health via curl
- [ ] Returner exit code 0 (frisk) eller 1 (syk)
- [ ] Legg til timeout-parameter" \
"enhancement,shell,healthcheck,linux"

issue "[E9-5] Lag backup.sh for sikkerhetskopiering av indeks" \
"Ta backup av FAISS-indeksen til datestemplet tarball.

**Oppgaver**
- [ ] tar -czf av indexes/ med dato i filnavn
- [ ] Rydd opp backups eldre enn N dager" \
"enhancement,shell,linux"

# --- Epic 10 ---
echo "==> Epic 10 – CI pipeline"
issue "[E10-1] Sett opp GitHub Actions CI workflow" \
"Enkel CI som kjøres på alle PRs og pushes til main.

**Oppgaver**
- [ ] Opprett .github/workflows/ci.yml
- [ ] Kjør ruff check og pytest
- [ ] Legg til status-badge i README" \
"ci"

issue "[E10-2] Legg til linting med ruff i CI" \
"Automatisert linting hindrer kodestil-diskusjoner i code review.

**Oppgaver**
- [ ] Konfigurer ruff i pyproject.toml
- [ ] Legg til ruff-steg i CI
- [ ] Fiks alle eksisterende linting-feil" \
"ci,python"

issue "[E10-3] Legg til pytest og testdekning i CI" \
"Enhetstester for kjernelogikk, kjørt automatisk.

**Oppgaver**
- [ ] Opprett tests/ med conftest.py
- [ ] Tester for chunk_text(), /health, /query
- [ ] Legg til pytest-cov (dekning > 60%)" \
"ci,python"

issue "[E10-4] Verifiser Docker build i CI" \
"Bekreft at Dockerfile alltid kan bygges.

**Oppgaver**
- [ ] Legg til docker build-steg i CI
- [ ] Enkel smoke test (healthcheck)" \
"ci,docker"

issue "[E10-5] Sikkerhetsskanning av avhengigheter" \
"Automatisk CVE-varsling for Python-pakker.

**Oppgaver**
- [ ] Aktiver Dependabot i .github/dependabot.yml
- [ ] Legg til pip-audit i CI" \
"ci,security"

# --- Epic 11 ---
echo "==> Epic 11 – Reverse proxy"
issue "[E11-1] Nginx-konfigurasjon som reverse proxy" \
"Nginx foran FastAPI med korrekte headers og timeouts.

**Oppgaver**
- [ ] Opprett nginx/nginx.conf
- [ ] Konfigurer proxy_pass til FastAPI
- [ ] Videresend X-Forwarded-For og X-Real-IP" \
"enhancement,nginx,infra"

issue "[E11-2] Integrer nginx i docker-compose" \
"Legg til nginx-service og eksponer port 80 i stedet for 8000.

**Oppgaver**
- [ ] Legg til nginx-service i docker-compose.yml
- [ ] Koble via internt Docker-nettverk
- [ ] Oppdater README" \
"enhancement,nginx,docker"

issue "[E11-3] Rate limiting i nginx" \
"Begrens forespørsler per IP for å unngå misbruk.

**Oppgaver**
- [ ] Legg til limit_req_zone i nginx.conf
- [ ] Returner 429 ved for mange requests" \
"enhancement,nginx,security"

issue "[E11-4] Dokumenter SSL/TLS oppsett med self-signed sertifikat" \
"Script og dokumentasjon for HTTPS lokalt.

**Oppgaver**
- [ ] Skriv scripts/generate-certs.sh med openssl
- [ ] Oppdater nginx.conf med SSL-konfigurasjon
- [ ] Legg til certs/ i .gitignore" \
"documentation,security,nginx,linux"

# --- Epic 12 ---
echo "==> Epic 12 – Kubernetes"
issue "[E12-1] Lag k8s/ mappe med Deployment manifest" \
"Kubernetes Deployment-manifest for fremtidig orchestrering.

**Oppgaver**
- [ ] Opprett k8s/deployment.yaml med ressursgrenser
- [ ] Legg til liveness- og readiness-probes" \
"enhancement,kubernetes,infra"

issue "[E12-2] Legg til ConfigMap og Secret templates" \
"Kubernetes-måten å håndtere konfigurasjon.

**Oppgaver**
- [ ] Opprett k8s/configmap.yaml
- [ ] Opprett k8s/secret.yaml.example (aldri ekte verdier)" \
"enhancement,kubernetes,config"

issue "[E12-3] Legg til Service og Ingress manifester" \
"Eksponer appen eksternt via Kubernetes Ingress.

**Oppgaver**
- [ ] Opprett k8s/service.yaml (ClusterIP)
- [ ] Opprett k8s/ingress.yaml med nginx ingress class" \
"enhancement,kubernetes"

issue "[E12-4] Legg til PersistentVolumeClaim for dokumentlagring" \
"Persistent lagring av dokumenter og indekser i Kubernetes.

**Oppgaver**
- [ ] Opprett k8s/pvc.yaml
- [ ] Oppdater Deployment til å mounte PVC" \
"enhancement,kubernetes"

echo ""
echo "✅ Ferdig! Se issues på: https://github.com/${REPO}/issues"
