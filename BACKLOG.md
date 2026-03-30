# Prosjektbacklog – Eksamen RAG / Lokal Document AI Service

> **Prosjektmål:** Bygge en lokal-first dokumenttjeneste med AI-søk, containerisering, automatisert drift og tydelig infrastruktur-oppsett – og demonstrere relevant kompetanse for en DevOps-/applikasjonsdrift-stilling.

---

## Epics oversikt

| # | Epic | Prioritet |
|---|------|-----------|
| E1 | [Project Foundation & Repo Hygiene](#epic-1-project-foundation--repo-hygiene) | 🔴 Kritisk |
| E2 | [Document Ingestion Pipeline](#epic-2-document-ingestion-pipeline) | 🔴 Kritisk |
| E3 | [Embeddings & Vector Store](#epic-3-embeddings--vector-store) | 🔴 Høy |
| E4 | [Query & Search API](#epic-4-query--search-api) | 🔴 Høy |
| E5 | [Configuration & Environment Management](#epic-5-configuration--environment-management) | 🟠 Høy |
| E6 | [Logging & Error Handling](#epic-6-logging--error-handling) | 🟠 Høy |
| E7 | [Healthchecks & Observability](#epic-7-healthchecks--observability) | 🟠 Høy |
| E8 | [Docker & Containerization](#epic-8-docker--containerization) | 🔴 Kritisk |
| E9 | [Shell Scripts & Automation](#epic-9-shell-scripts--automation) | 🟠 Høy |
| E10 | [CI Pipeline](#epic-10-ci-pipeline) | 🟡 Medium |
| E11 | [Reverse Proxy & Networking](#epic-11-reverse-proxy--networking) | 🟡 Medium |
| E12 | [Kubernetes/OpenShift-Inspired Structure](#epic-12-kubernetesopenshift-inspired-structure) | 🟢 Lav |

---

## Epic 1: Project Foundation & Repo Hygiene

### Issue E1-1 – Initialize Python project with pyproject.toml

**🎯 Goal:**
Bytt ut den enkle `requirements.txt` med en modern `pyproject.toml` som definerer avhengigheter, Python-versjon og prosjektmetadata.

**💡 Why it matters:**
`pyproject.toml` er standard i moderne Python-prosjekter og gjør det enklere å styre versjoner, bygge pakker og integrere med linters/CI-verktøy. Viser Python-kompetanse utover det grunnleggende.

**📋 Tasks:**
- [ ] Opprett `pyproject.toml` med `[project]`-seksjon (navn, versjon, Python-krav)
- [ ] Flytt avhengigheter fra `requirements.txt` inn i `pyproject.toml` under `[project.dependencies]`
- [ ] Legg til dev-avhengigheter (`pytest`, `ruff`, `httpx`) under `[project.optional-dependencies]`
- [ ] Opprett `requirements.txt` via `pip freeze` (for bakoverkompatibilitet med Docker)
- [ ] Oppdater README med ny installasjonsinstruksjon

**✅ Acceptance criteria:**
- `pip install -e ".[dev]"` fungerer uten feil
- `pyproject.toml` er eneste kilde til sannhet for avhengigheter
- CI-pipeline kan bruke `pyproject.toml`

**🏷️ Labels:** `enhancement`, `repo-hygiene`, `python`
**⚡ Priority:** P1 – Gjøres først

---

### Issue E1-2 – Set up comprehensive README

**🎯 Goal:**
Skriv en README som forklarer prosjektet, arkitektur, hvordan man kjører det lokalt og med Docker, og hva hver komponent gjør.

**💡 Why it matters:**
En god README er det første en teknisk intervjuer ser. Den signaliserer ryddighet, dokumentasjonskultur og at man tenker på andres opplevelse – viktige egenskaper for en driftsrolle.

**📋 Tasks:**
- [ ] Legg til prosjektbeskrivelse og mål
- [ ] Dokumenter arkitekturdiagram (tekst eller ASCII-art)
- [ ] Legg til "Quick start" (lokal kjøring)
- [ ] Legg til "Docker quick start"
- [ ] Dokumenter alle API-endepunkter med eksempel-kall (curl)
- [ ] Legg til seksjoner: Prerequisites, Environment Variables, Project Structure

**✅ Acceptance criteria:**
- En ny utvikler kan sette opp og kjøre prosjektet kun ved å følge README
- Alle API-endepunkter er dokumentert med eksempel

**🏷️ Labels:** `documentation`, `repo-hygiene`
**⚡ Priority:** P1 – Gjøres tidlig

---

### Issue E1-3 – Add CONTRIBUTING.md and development setup guide

**🎯 Goal:**
Dokumenter prosessen for å bidra til prosjektet: branch-navngiving, commit-konvensjon, lokal oppsett og PR-prosess.

**💡 Why it matters:**
Viser profesjonelt tankegang rundt teamarbeid og repo-hygiene. Viktig for DevOps-roller der man forventer prosessdisiplin og dokumentasjon.

**📋 Tasks:**
- [ ] Opprett `CONTRIBUTING.md`
- [ ] Beskriv branch-navngiving (`feature/`, `fix/`, `infra/`)
- [ ] Beskriv commit-message-konvensjon (Conventional Commits)
- [ ] Dokumenter lokal utviklings-setup (virtualenv, `.env`-fil)
- [ ] Beskriv PR-prosessen

**✅ Acceptance criteria:**
- `CONTRIBUTING.md` finnes og er lesbar
- Konvensjonene er konsistente med eksisterende commits

**🏷️ Labels:** `documentation`, `repo-hygiene`
**⚡ Priority:** P2

---

### Issue E1-4 – Add .editorconfig and code style configuration

**🎯 Goal:**
Legg til `.editorconfig` og `ruff`-konfigurasjon i `pyproject.toml` slik at hele prosjektet følger konsistent kodestil.

**💡 Why it matters:**
Konsistent formatering reduserer diff-støy, gjør code review lettere og signaliserer at man jobber profesjonelt. Ruff er moderne og rask – brukes i enterprise-Python-prosjekter.

**📋 Tasks:**
- [ ] Opprett `.editorconfig` (indentasjon, linjeavslutning, charset)
- [ ] Legg til `[tool.ruff]`-seksjon i `pyproject.toml`
- [ ] Konfigurer ruff-regler (E, F, I, UP minimum)
- [ ] Kjør `ruff format .` og fikse eksisterende stilfeil
- [ ] Dokumenter i README hvordan man kjører linter

**✅ Acceptance criteria:**
- `ruff check .` passerer uten feil
- `.editorconfig` er på plass

**🏷️ Labels:** `repo-hygiene`, `code-quality`, `python`
**⚡ Priority:** P2

---

## Epic 2: Document Ingestion Pipeline

### Issue E2-1 – Fix and complete the ingest_documents() function

**🎯 Goal:**
Fix den uferdige `ingest_documents()`-funksjonen i `app/services/ingestion.py` som inneholder en syntaksfeil og mangler implementasjon.

**💡 Why it matters:**
Ingestion er grunnmuren i hele RAG-pipelinen. Uten fungerende ingestion kan ikke systemet indeksere dokumenter og søket vil aldri fungere.

**📋 Tasks:**
- [ ] Fiks syntaksfeil på linje 40 (løs variabel `f`)
- [ ] Fullfør loop som samler alle chunks fra alle dokumenter
- [ ] Returner liste med `{filename, chunk_index, content}` per chunk
- [ ] Legg til feilhåndtering for filer som ikke kan leses
- [ ] Skriv enkel unit test for `ingest_documents()`

**✅ Acceptance criteria:**
- `ingest_documents()` returnerer liste med chunks
- Syntaksfeil er borte
- Feil i enkeltfiler stopper ikke ingestion av resten
- Unit test passerer

**🏷️ Labels:** `bug`, `ingestion`, `python`
**⚡ Priority:** P0 – Kritisk bugfix

---

### Issue E2-2 – Support multiple document formats (.txt, .md, .pdf)

**🎯 Goal:**
Utvid `load_documents()` til å støtte `.txt`, `.md` og `.pdf`-filer (PDF via `pypdf`).

**💡 Why it matters:**
Reelle dokumenttjenester må håndtere varierte filformater. Viser at man tenker på faktisk bruk, ikke bare happy path.

**📋 Tasks:**
- [ ] Legg til `pypdf` i avhengigheter
- [ ] Implementer `read_pdf(filepath)` funksjon
- [ ] Oppdater `load_documents()` til å rute basert på filtype
- [ ] Håndter encoding-feil for tekstfiler
- [ ] Logg hvilke filer som hoppes over (ukjent format)
- [ ] Test med en `.txt`, `.md` og `.pdf` i `documents/`

**✅ Acceptance criteria:**
- `.txt`, `.md` og `.pdf` filer leses korrekt
- Ukjente filtyper logges og hoppes over
- Unit tests dekker alle tre filtyper

**🏷️ Labels:** `enhancement`, `ingestion`, `python`
**⚡ Priority:** P1

---

### Issue E2-3 – Implement text chunking with configurable size and overlap

**🎯 Goal:**
Forbedre `chunk_text()`-funksjonen til å støtte konfigurerbar chunk-størrelse og overlapp mellom chunks.

**💡 Why it matters:**
Overlapping chunks bedrer søkekvaliteten ved å unngå at viktig kontekst kuttes midt i en setning. Konfigurerbarhet via env-variabler viser forståelse for 12-factor app-prinsipper.

**📋 Tasks:**
- [ ] Legg til `chunk_overlap`-parameter i `chunk_text()`
- [ ] Legg til `CHUNK_SIZE` og `CHUNK_OVERLAP` i `Settings`
- [ ] Oppdater `.env.example` med nye variabler
- [ ] Skriv unit tests for chunking med og uten overlapp
- [ ] Valider at chunk_overlap < chunk_size

**✅ Acceptance criteria:**
- Chunks overlapper med konfigurert antall tegn
- Chunk-størrelse og overlapp er konfigurerbar via env
- Unit tests passerer
- `.env.example` er oppdatert

**🏷️ Labels:** `enhancement`, `ingestion`, `config`
**⚡ Priority:** P1

---

### Issue E2-4 – Add POST /ingest API endpoint

**🎯 Goal:**
Legg til et `POST /ingest`-endepunkt som trigger ingestion av alle dokumenter i `DOCUMENTS_PATH` og returnerer en oppsummering.

**💡 Why it matters:**
Gjør ingestion triggerbar via API, noe som er nødvendig for automatisering og CI/CD-integrasjon. Viser RESTful API-design.

**📋 Tasks:**
- [ ] Legg til `POST /ingest` i `app/api/routes.py`
- [ ] Returner `{status, files_processed, chunks_created, duration_ms}`
- [ ] Håndter feil med passende HTTP-statuskoder
- [ ] Logg start og slutt på ingestion med tidsmåling
- [ ] Test endepunktet med `curl`

**✅ Acceptance criteria:**
- `POST /ingest` returnerer 200 med statistikk
- Feil returnerer 500 med beskrivende feilmelding
- Ingestion logges med varighet

**🏷️ Labels:** `enhancement`, `ingestion`, `api`
**⚡ Priority:** P2

---

### Issue E2-5 – Add ingestion idempotency and change detection

**🎯 Goal:**
Unngå re-ingesting av dokumenter som ikke har endret seg siden sist ved å lagre filhash/tidsstempel.

**💡 Why it matters:**
Viktig for ytelse og driftseffektivitet. Viser forståelse for stateful systemer og idempotente operasjoner – et sentralt DevOps-tema.

**📋 Tasks:**
- [ ] Lagre MD5-hash per fil i en enkel JSON-fil
- [ ] Sjekk hash ved re-ingesting – hopp over uendrede filer
- [ ] Legg til `force=true`-parameter for å tvinge full re-ingestion
- [ ] Logg hvilke filer som ble hoppet over

**✅ Acceptance criteria:**
- Uendrede filer re-ingestas ikke
- `POST /ingest?force=true` tvinger full re-ingestion
- Endret fil detekteres og re-ingestas

**🏷️ Labels:** `enhancement`, `ingestion`, `performance`
**⚡ Priority:** P3

---

## Epic 3: Embeddings & Vector Store

### Issue E3-1 – Integrate sentence-transformers for local embeddings

**🎯 Goal:**
Integrer `sentence-transformers` biblioteket for å generere lokale vektorrepresentasjoner (embeddings) av tekst-chunks.

**💡 Why it matters:**
Lokale embeddings er kjernen i en lokal-first RAG-løsning. Ingen ekstern API nødvendig – alt kjøres offline. Viser forståelse for ML-infrastruktur.

**📋 Tasks:**
- [ ] Legg til `sentence-transformers` i avhengigheter
- [ ] Opprett `app/services/embeddings.py`
- [ ] Implementer `get_embedding(text: str) -> list[float]`
- [ ] Legg til `EMBEDDING_MODEL` i `Settings` (default: `all-MiniLM-L6-v2`)
- [ ] Implementer lazy loading av modell (last ved første kall)
- [ ] Logg hvilken modell som lastes

**✅ Acceptance criteria:**
- `get_embedding("test")` returnerer en liste med floats
- Modellnavn er konfigurerbart via env
- Modell lastes kun én gang per oppstart

**🏷️ Labels:** `enhancement`, `embeddings`, `ai`
**⚡ Priority:** P1

---

### Issue E3-2 – Set up FAISS vector store

**🎯 Goal:**
Integrer FAISS som lokal vektordatabase for å lagre og søke i embeddings.

**💡 Why it matters:**
FAISS er standard for lokal vektorsøk – brukes i produksjonssystemer hos Meta og mange andre. Viser konkret kjennskap til AI-infrastruktur-verktøy.

**📋 Tasks:**
- [ ] Legg til `faiss-cpu` i avhengigheter
- [ ] Opprett `app/services/vector_store.py`
- [ ] Implementer `VectorStore`-klasse med `add()` og `search()` metoder
- [ ] Lagre metadata (filename, chunk_index) separat som liste parallelt med FAISS-indeks
- [ ] Skriv unit test for add og search

**✅ Acceptance criteria:**
- `VectorStore.add(embedding, metadata)` legger til vektor
- `VectorStore.search(embedding, k=5)` returnerer top-k resultater
- Unit tests passerer

**🏷️ Labels:** `enhancement`, `vector-store`, `ai`
**⚡ Priority:** P1

---

### Issue E3-3 – Implement end-to-end indexing pipeline

**🎯 Goal:**
Koble ingestion → chunking → embedding → FAISS i en sammenhengende indekseringspipeline.

**💡 Why it matters:**
Pipeline-tenkning er sentralt i DevOps. Viser evne til å koble komponenter til et fungerende system.

**📋 Tasks:**
- [ ] Opprett `app/services/indexer.py`
- [ ] Implementer `build_index()` som kjører full pipeline
- [ ] Integrer med `POST /ingest`-endepunktet
- [ ] Logg fremdrift: antall chunks prosessert
- [ ] Mål og logg total tid for indeksering

**✅ Acceptance criteria:**
- `build_index()` produserer FAISS-indeks fra dokumenter i `DOCUMENTS_PATH`
- `POST /ingest` kaller `build_index()` og returnerer statistikk
- Fremdrift logges

**🏷️ Labels:** `enhancement`, `ingestion`, `embeddings`, `ai`
**⚡ Priority:** P1

---

### Issue E3-4 – Persist FAISS index to disk

**🎯 Goal:**
Lagre FAISS-indeksen til disk slik at den overlever container-restart, og last den inn automatisk ved oppstart.

**💡 Why it matters:**
Persistens er et grunnleggende driftsprinsipp. Viser forståelse for stateful tjenester, volum-mounts i Docker, og graceful startup.

**📋 Tasks:**
- [ ] Implementer `save_index(path)` og `load_index(path)` i `VectorStore`
- [ ] Bruk `INDEX_PATH` fra `Settings`
- [ ] Last eksisterende indeks ved applikasjonsoppstart i `main.py`
- [ ] Logg om indeks ble lastet fra disk eller starter tom
- [ ] Håndter korrupt indeksfil med feilmelding og tom oppstart

**✅ Acceptance criteria:**
- Indeks lagres til `INDEX_PATH` etter `build_index()`
- Indeks lastes automatisk ved oppstart
- Korrupt fil gir logg-advarsel, ikke crash

**🏷️ Labels:** `enhancement`, `vector-store`, `persistence`
**⚡ Priority:** P2

---

### Issue E3-5 – Add GET /index/status endpoint

**🎯 Goal:**
Legg til et endepunkt som returnerer status for FAISS-indeksen: antall vektorer, modell, sist oppdatert.

**💡 Why it matters:**
Operasjonell synlighet er viktig for drift. Viser at man tenker på observability utover bare healthchecks.

**📋 Tasks:**
- [ ] Legg til `GET /index/status` i routes
- [ ] Returner `{vector_count, embedding_model, last_indexed, index_size_bytes}`
- [ ] Returner 204 om indeks ikke finnes ennå

**✅ Acceptance criteria:**
- `GET /index/status` returnerer korrekt info
- 204 returneres om indeks ikke er bygget

**🏷️ Labels:** `enhancement`, `api`, `observability`
**⚡ Priority:** P2

---

## Epic 4: Query & Search API

### Issue E4-1 – Implement semantic search using FAISS

**🎯 Goal:**
Implementer faktisk semantisk søk i `run_query()` ved å bruke embeddings + FAISS.

**💡 Why it matters:**
Dette er kjernefeature i hele RAG-systemet. Alt arbeid i Epic 2 og 3 konvergerer her.

**📋 Tasks:**
- [ ] Oppdater `run_query()` til å kalle `get_embedding()` på query
- [ ] Søk i FAISS-indeksen med query-embedding
- [ ] Returner topp-k mest relevante chunks med metadata
- [ ] Legg til `k`-parameter i query (default: 5)

**✅ Acceptance criteria:**
- `GET /query?q=<tekst>` returnerer relevante chunks
- Resultater inkluderer `filename`, `chunk_index`, `score` og `content`
- k er konfigurerbart

**🏷️ Labels:** `enhancement`, `search`, `ai`
**⚡ Priority:** P1

---

### Issue E4-2 – Add query validation and error handling

**🎯 Goal:**
Robust validering av query-parameteren med tydelige feilmeldinger og riktige HTTP-statuskoder.

**💡 Why it matters:**
Feilhåndtering er et av de første tingene en code reviewer ser på. Viser profesjonelt API-design.

**📋 Tasks:**
- [ ] Valider at `q` ikke er tom (allerede gjort – verifiser og test)
- [ ] Returner 503 om indeks ikke er bygget
- [ ] Returner 200 med tom resultatliste om ingen treff
- [ ] Legg til `MAX_QUERY_LENGTH` i config og valider
- [ ] Håndter exceptions i søk med 500-feil og logg

**✅ Acceptance criteria:**
- Tom query → 400
- Indeks ikke bygget → 503 med beskrivende melding
- Ingen treff → 200 med `results: []`
- Unhandled exception → 500 med log

**🏷️ Labels:** `enhancement`, `api`, `error-handling`
**⚡ Priority:** P2

---

### Issue E4-3 – Add result ranking and context window

**🎯 Goal:**
Returner resultater med score-basert rangering og inkluder naboer-chunks som kontekstuelt vindu.

**💡 Why it matters:**
Kontekstvindu forbedrer svarkvaliteten og er standard i RAG-implementasjoner.

**📋 Tasks:**
- [ ] Sorter resultater etter cosine similarity score (høyeste først)
- [ ] Legg til mulighet for å returnere chunk ± 1 naboer som context
- [ ] Legg til `include_context=true`-parameter
- [ ] Test at relevante chunks havner øverst

**✅ Acceptance criteria:**
- Resultater er sortert med beste match først
- `include_context=true` returnerer kontekst-chunks
- Score er normalisert mellom 0 og 1

**🏷️ Labels:** `enhancement`, `search`, `ai`
**⚡ Priority:** P3

---

### Issue E4-4 – Add POST /query endpoint for longer queries

**🎯 Goal:**
Legg til `POST /query` med JSON-body for å støtte lengre queries enn URL-grensen tillater.

**💡 Why it matters:**
Profesjonelt API-design har POST-endepunkter for søk med lange eller strukturerte forespørsler.

**📋 Tasks:**
- [ ] Opprett Pydantic-modell `QueryRequest`
- [ ] Legg til `POST /query` med `QueryRequest`-body
- [ ] Returner samme format som `GET /query`
- [ ] Dokumenter begge endepunkter i README

**✅ Acceptance criteria:**
- `POST /query` med `{"q": "...", "k": 5}` returnerer resultater
- Pydantic validerer input
- Begge endepunkter dokumentert

**🏷️ Labels:** `enhancement`, `api`
**⚡ Priority:** P3

---

## Epic 5: Configuration & Environment Management

### Issue E5-1 – Migrate config to Pydantic BaseSettings

**🎯 Goal:**
Bytt ut den enkle `Settings`-klassen med Pydantic `BaseSettings` for automatisk type-validering og .env-lasting.

**💡 Why it matters:**
Pydantic BaseSettings er industri-standard for konfigurasjonstyring i FastAPI-applikasjoner. Feil konfigurasjon feiler ved oppstart, ikke under kjøring.

**📋 Tasks:**
- [ ] Legg til `pydantic-settings` i avhengigheter
- [ ] Migrer `app/core/config.py` til `BaseSettings`
- [ ] Legg til typer og validering for alle felt
- [ ] Legg til `@validator` for `APP_ENV` (tillat kun: development, staging, production)
- [ ] Test at app feiler ved ugyldig konfigurasjon

**✅ Acceptance criteria:**
- Ugyldig env-verdi gir `ValidationError` med tydelig melding ved oppstart
- Typer er korrekte (int for port, etc.)
- `pydantic-settings` er i avhengigheter

**🏷️ Labels:** `enhancement`, `config`, `python`
**⚡ Priority:** P1

---

### Issue E5-2 – Document all environment variables

**🎯 Goal:**
Oppdater `.env.example` med alle miljøvariabler, standardverdier og beskrivende kommentarer.

**💡 Why it matters:**
`.env.example` er kontrakten mellom utvikler og driftsmiljø. En velkommentert `.env.example` er kritisk for DevOps og onboarding.

**📋 Tasks:**
- [ ] List alle eksisterende variabler med kommentarer
- [ ] Legg til nye variabler (CHUNK_SIZE, EMBEDDING_MODEL, etc.)
- [ ] Skill mellom required og optional variabler
- [ ] Dokumenter gyldige verdier for enum-typer (APP_ENV)
- [ ] Lenke til `.env.example` fra README

**✅ Acceptance criteria:**
- Alle variabler brukt i koden finnes i `.env.example`
- Kommentarer forklarer hva variabelen gjør og gyldige verdier
- Skille mellom required/optional er tydelig

**🏷️ Labels:** `documentation`, `config`
**⚡ Priority:** P1

---

### Issue E5-3 – Add startup configuration validation

**🎯 Goal:**
Valider kritiske konfigurasjoner ved oppstart og gi tydelig feilmelding om noe mangler.

**💡 Why it matters:**
Fail-fast er et DevOps-prinsipp. En app som feiler tydelig ved oppstart er langt lettere å drifte enn en som feiler stille under kjøring.

**📋 Tasks:**
- [ ] Legg til startup-event i `main.py` med konfigurasjonskontroll
- [ ] Sjekk at `DOCUMENTS_PATH` eksisterer (opprett om det ikke gjør det)
- [ ] Sjekk at `INDEX_PATH` er skrivbar
- [ ] Logg alle konfigurasjoner ved oppstart (maskér secrets)
- [ ] Test at app starter korrekt og feil feiler tydelig

**✅ Acceptance criteria:**
- Manglende `DOCUMENTS_PATH` logges med advarsel, men stopper ikke app
- Konfigurasjoner logges ved oppstart
- Ingen secrets logges i klartekst

**🏷️ Labels:** `enhancement`, `config`, `operational`
**⚡ Priority:** P2

---

### Issue E5-4 – Support production mode with stricter settings

**🎯 Goal:**
Legg til `APP_ENV=production`-modus som aktiverer strengere innstillinger: ingen reload, JSON-logging, høyere log-terskel.

**💡 Why it matters:**
Skille mellom dev og prod er grunnleggende i enhver applikasjonsdrift-rolle. Viser at man tenker på drift fra dag én.

**📋 Tasks:**
- [ ] Bruk `APP_ENV` til å sette log-nivå i `main.py`
- [ ] Slå av FastAPI debug-modus i prod
- [ ] Aktiver JSON-logging i prod (se Epic 6)
- [ ] Dokumenter forskjellen i README

**✅ Acceptance criteria:**
- `APP_ENV=production` gir JSON-logging og INFO-nivå
- `APP_ENV=development` gir lesbar tekst-logging og DEBUG-nivå
- Dokumentert i README

**🏷️ Labels:** `enhancement`, `config`, `operational`
**⚡ Priority:** P2

---

## Epic 6: Logging & Error Handling

### Issue E6-1 – Implement structured JSON logging

**🎯 Goal:**
Konfigurer logging til å outputte JSON-formatert logg i produksjon slik at logg-aggregatorer (Loki, ELK) kan parse dem.

**💡 Why it matters:**
Strukturert logging er standard i moderne DevOps. Det er det første man setter opp i et driftsmiljø for å kunne søke og filtrere logger effektivt.

**📋 Tasks:**
- [ ] Legg til `python-json-logger` i avhengigheter
- [ ] Opprett `app/core/logging_config.py` med logging-oppsett
- [ ] Bruk JSON-formatter i prod, tekst i dev (basert på APP_ENV)
- [ ] Inkluder `timestamp`, `level`, `logger`, `message`, `env` i alle logg-meldinger
- [ ] Oppdater `main.py` til å bruke ny logging-konfigurasjon

**✅ Acceptance criteria:**
- I produksjon produseres én JSON-linje per logg-event
- I development produseres lesbar tekst-logg
- Alle eksisterende logg-kall fungerer uten endring

**🏷️ Labels:** `enhancement`, `logging`, `operational`
**⚡ Priority:** P1

---

### Issue E6-2 – Add request/response logging middleware

**🎯 Goal:**
Legg til FastAPI-middleware som logger alle innkommende forespørsler og utgående responser med metode, path, statuskode og varighet.

**💡 Why it matters:**
Request-logging er kritisk for drift og feilsøking. Uten dette er det vanskelig å debugge problemer i produksjon.

**📋 Tasks:**
- [ ] Opprett `app/api/middleware.py`
- [ ] Implementer `LoggingMiddleware` med `starlette.middleware`
- [ ] Logg: `method`, `path`, `status_code`, `duration_ms`
- [ ] Logg på INFO-nivå, feil (5xx) på ERROR-nivå
- [ ] Test at alle endepunkter logges

**✅ Acceptance criteria:**
- Alle HTTP-kall logges med statuskode og varighet
- 5xx-feil logges på ERROR-nivå
- Middleware er registrert i `main.py`

**🏷️ Labels:** `enhancement`, `logging`, `api`
**⚡ Priority:** P1

---

### Issue E6-3 – Add global exception handler

**🎯 Goal:**
Legg til global exception handler som fanger uventede feil og returnerer konsistente JSON-feilresponser i stedet for stack traces.

**💡 Why it matters:**
Stack traces i API-responser er et sikkerhets- og driftsproblem. Konsistente feilresponser gjør det lettere for klienter og driftsverktøy å håndtere feil.

**📋 Tasks:**
- [ ] Legg til `@app.exception_handler(Exception)` i `main.py`
- [ ] Returner `{"error": "Internal server error", "detail": null}` i prod
- [ ] Returner detaljer i dev (`APP_ENV=development`)
- [ ] Logg alle unhandled exceptions med stack trace
- [ ] Test med et endepunkt som kaster en exception

**✅ Acceptance criteria:**
- Uventede feil returnerer 500 med JSON-respons
- Stack trace logges men ikke eksponeres i prod
- Test demonstrerer oppførselen

**🏷️ Labels:** `enhancement`, `error-handling`, `api`, `security`
**⚡ Priority:** P2

---

### Issue E6-4 – Add correlation ID to requests

**🎯 Goal:**
Generer en unik `X-Request-ID` header for hvert kall og inkluder den i alle logg-meldinger og responser.

**💡 Why it matters:**
Correlation IDs er fundamentalt for distributed tracing og feilsøking. Viser forståelse for observability i produksjonssystemer.

**📋 Tasks:**
- [ ] Generer UUID per request i middleware
- [ ] Legg til request-ID i logg-meldinger (via context var)
- [ ] Returner `X-Request-ID` i alle responser
- [ ] Aksepter eksisterende `X-Request-ID` fra klient (pass-through)

**✅ Acceptance criteria:**
- Alle logg-linjer for et kall har samme request-ID
- `X-Request-ID` header returneres i alle svar
- Klientens ID brukes om den sendes inn

**🏷️ Labels:** `enhancement`, `logging`, `observability`
**⚡ Priority:** P3

---

### Issue E6-5 – Configure log rotation

**🎯 Goal:**
Konfigurer logging til å skrive til fil med automatisk rotasjon slik at disk ikke fylles opp.

**💡 Why it matters:**
Log rotation er standard Linux/driftspraksis. Manglende rotasjon er en vanlig årsak til full disk i produksjon.

**📋 Tasks:**
- [ ] Legg til `RotatingFileHandler` i logging-konfigurasjon
- [ ] Lagre logger i `logs/`-mappen (allerede i `.gitignore`)
- [ ] Konfigurer maks fil-størrelse og antall backup-filer via env
- [ ] Dokumenter log-plassering i README
- [ ] Test at rotasjon skjer korrekt

**✅ Acceptance criteria:**
- Logger skrives til `logs/app.log`
- Fil roteres automatisk ved nådd størrelse
- Antall backup-filer er konfigurerbart

**🏷️ Labels:** `enhancement`, `logging`, `operational`
**⚡ Priority:** P3

---

## Epic 7: Healthchecks & Observability

### Issue E7-1 – Enhance /health endpoint with system checks

**🎯 Goal:**
Utvid `/health`-endepunktet til å rapportere system-status inkludert diskplass, indeks-tilstand og embedding-modell.

**💡 Why it matters:**
Et enkelt `{"status": "ok"}` er ikke nok for et produksjonssystem. Rik helseinformasjon er avgjørende for monitorering og auto-healing.

**📋 Tasks:**
- [ ] Sjekk at `DOCUMENTS_PATH` er tilgjengelig
- [ ] Rapporter om indeks er lastet og antall vektorer
- [ ] Rapporter tilgjengelig diskplass (via `shutil.disk_usage`)
- [ ] Rapporter embedding-modell-status (lastet/ikke lastet)
- [ ] Returner HTTP 200 om alt ok, 503 om kritisk feil

**✅ Acceptance criteria:**
- `/health` returnerer utvidet JSON med alle sjekker
- 503 returneres om diskplass < 100MB
- Respons er < 200ms

**🏷️ Labels:** `enhancement`, `healthcheck`, `observability`
**⚡ Priority:** P1

---

### Issue E7-2 – Add /ready readiness probe endpoint

**🎯 Goal:**
Legg til `/ready`-endepunkt som returnerer 200 kun når appen er fullt initialisert og klar til å betjene requests.

**💡 Why it matters:**
Readiness/liveness skillet er fundamentalt i Kubernetes og containerdrift. Viser konkret kunnskap om container-orchestrering.

**📋 Tasks:**
- [ ] Legg til `/ready`-endepunkt
- [ ] Sjekk at embedding-modell er lastet
- [ ] Returner 503 under oppstart, 200 når klar
- [ ] Dokumenter forskjellen mellom `/health` og `/ready` i README

**✅ Acceptance criteria:**
- `/ready` returnerer 503 om modell ikke er lastet
- `/ready` returnerer 200 når alt er initialisert
- Endepunktet er dokumentert

**🏷️ Labels:** `enhancement`, `healthcheck`, `kubernetes`
**⚡ Priority:** P2

---

### Issue E7-3 – Add disk usage and uptime to health response

**🎯 Goal:**
Legg til operasjonell metadata i health-responsen: uptime, disk-bruk, prosess-ID.

**💡 Why it matters:**
Viser forståelse for hva driftsteam trenger fra en helsesjekk. Uptime og disk-bruk er standardinfo i produksjonsmiljøer.

**📋 Tasks:**
- [ ] Legg til `uptime_seconds` (tid siden oppstart)
- [ ] Legg til `disk_free_gb` og `disk_used_percent`
- [ ] Legg til `pid` (prosess-ID)
- [ ] Legg til `version` fra `pyproject.toml`

**✅ Acceptance criteria:**
- Alle felt er til stede i health-responsen
- Verdier er korrekte og oppdateres per kall

**🏷️ Labels:** `enhancement`, `healthcheck`, `observability`
**⚡ Priority:** P2

---

### Issue E7-4 – Add basic /metrics endpoint

**🎯 Goal:**
Legg til et enkelt `/metrics`-endepunkt med applikasjonsstatistikk: antall forespørsler, dokumenter, chunks.

**💡 Why it matters:**
Metrics er første skritt mot Prometheus-integrasjon. Viser at man tenker på operasjonell synlighet.

**📋 Tasks:**
- [ ] Tell antall requests siden oppstart (per endepunkt)
- [ ] Returner `{total_requests, documents_indexed, chunks_indexed, queries_served}`
- [ ] Bruk in-memory counter (ikke Prometheus ennå)
- [ ] Dokumenter i README

**✅ Acceptance criteria:**
- `/metrics` returnerer korrekt statistikk
- Tellerene øker med bruk
- Dokumentert i README

**🏷️ Labels:** `enhancement`, `observability`, `metrics`
**⚡ Priority:** P3

---

## Epic 8: Docker & Containerization

### Issue E8-1 – Create production-ready Dockerfile

**🎯 Goal:**
Skriv en `Dockerfile` med multi-stage build som produserer et minimalt, sikkert produksjonsimage.

**💡 Why it matters:**
Docker er kjernen i moderne applikasjonsdrift. Et riktig Dockerfile med multi-stage build viser konkret container-kompetanse.

**📋 Tasks:**
- [ ] Opprett `Dockerfile` med to stages: `builder` og `runtime`
- [ ] Bruk `python:3.11-slim` som base image
- [ ] Installer avhengigheter i builder, kopier kun nødvendig til runtime
- [ ] Kjør som non-root user (`appuser`)
- [ ] Sett `WORKDIR /app`
- [ ] Eksponer riktig port via `EXPOSE`
- [ ] Legg til `HEALTHCHECK`-instruksjon

**✅ Acceptance criteria:**
- `docker build -t eksamen-rag .` bygger uten feil
- Container kjører som non-root
- `docker run` starter appen
- Image-størrelse er dokumentert

**🏷️ Labels:** `enhancement`, `docker`, `infra`
**⚡ Priority:** P1 – Gjøres tidlig

---

### Issue E8-2 – Create .dockerignore

**🎯 Goal:**
Legg til `.dockerignore` for å holde Docker build context liten og unngå å kopiere unødvendige filer inn i imagen.

**💡 Why it matters:**
`.dockerignore` er en liten men viktig detalj som viser at man forstår Docker build-prosessen og tenker på ytelse.

**📋 Tasks:**
- [ ] Opprett `.dockerignore`
- [ ] Ekskluder: `.git`, `.venv`, `__pycache__`, `*.pyc`, `logs/`, `indexes/`, `.env`, `*.md`
- [ ] Test at build context er liten med `docker build --progress=plain`

**✅ Acceptance criteria:**
- `.dockerignore` finnes og ekskluderer riktige filer
- Build context er < 1MB

**🏷️ Labels:** `enhancement`, `docker`, `repo-hygiene`
**⚡ Priority:** P1

---

### Issue E8-3 – Create docker-compose.yml for local development

**🎯 Goal:**
Skriv en `docker-compose.yml` som gjør det enkelt å kjøre hele applikasjonen lokalt med ett kommando.

**💡 Why it matters:**
`docker-compose` er standard i DevOps-miljøer for lokal utvikling. Viser praktisk container-orkestrerings-erfaring.

**📋 Tasks:**
- [ ] Opprett `docker-compose.yml`
- [ ] Definer `app`-service med build og port-mapping
- [ ] Les miljøvariabler fra `.env`-fil
- [ ] Legg til `restart: unless-stopped`
- [ ] Dokumenter `docker-compose up` i README
- [ ] Test at `docker-compose up` starter appen

**✅ Acceptance criteria:**
- `docker-compose up` starter appen på port 8000
- `docker-compose down` stopper alt
- README beskriver kommandoene

**🏷️ Labels:** `enhancement`, `docker`, `infra`
**⚡ Priority:** P1

---

### Issue E8-4 – Configure volume mounts for documents and indexes

**🎯 Goal:**
Konfigurer Docker volum-mounts slik at `documents/` og `indexes/` er persistente og kan administreres utenfor containeren.

**💡 Why it matters:**
Volum-mounts er kritisk for stateful containere. Viser forståelse for persistent storage i Docker – et kjernetema i driftsroller.

**📋 Tasks:**
- [ ] Legg til named volumes for `documents` og `indexes` i `docker-compose.yml`
- [ ] Alternativt: bind-mount til lokale mapper (`./documents:/app/documents`)
- [ ] Dokumenter hvordan man legger til dokumenter uten å bygge om imagen
- [ ] Legg til kommentarer i `docker-compose.yml`

**✅ Acceptance criteria:**
- Dokumenter kan legges til uten container rebuild
- Indekser overlever container restart
- Dokumentert i README

**🏷️ Labels:** `enhancement`, `docker`, `infra`, `storage`
**⚡ Priority:** P2

---

### Issue E8-5 – Add Docker environment variable documentation

**🎯 Goal:**
Dokumenter alle støttede miljøvariabler for Docker-kjøring i README og docker-compose.

**💡 Why it matters:**
Tydelig konfigurasjonsdokumentasjon er en forutsetning for god drift. Reduserer onboarding-tid og feil.

**📋 Tasks:**
- [ ] Dokumenter alle env-variabler brukt av Docker-imagen
- [ ] Legg til `environment`-seksjon med kommentarer i `docker-compose.yml`
- [ ] Lag en tabell i README: Variabel | Default | Beskrivelse
- [ ] Test at appen startes korrekt med og uten `.env`-fil

**✅ Acceptance criteria:**
- README har en komplett env-variabel-tabell
- `docker-compose.yml` har `environment`-seksjon med kommentarer
- Appen fungerer med standardverdier alene

**🏷️ Labels:** `documentation`, `docker`, `config`
**⚡ Priority:** P2

---

## Epic 9: Shell Scripts & Automation

### Issue E9-1 – Create start.sh and stop.sh scripts

**🎯 Goal:**
Opprett `scripts/start.sh` og `scripts/stop.sh` for å starte og stoppe applikasjonen (både lokal og Docker-modus).

**💡 Why it matters:**
Shell scripts er et daglig verktøy i Linux/DevOps-arbeid. Å ha ryddige, dokumenterte scripts viser praktisk Linux-kompetanse.

**📋 Tasks:**
- [ ] Opprett `scripts/`-mappe
- [ ] Skriv `start.sh` som starter appen (velger mellom lokal og Docker basert på `--docker`-flagg)
- [ ] Skriv `stop.sh` som stopper containere eller prosessen
- [ ] Legg til `set -euo pipefail` øverst i begge scripts
- [ ] Legg til usage-dokumentasjon i script-hodene
- [ ] Gjør scriptene kjørbare (`chmod +x`)

**✅ Acceptance criteria:**
- `./scripts/start.sh` starter appen lokalt
- `./scripts/start.sh --docker` bruker Docker
- `./scripts/stop.sh` stopper pent
- Scripts har `set -euo pipefail` og usage-hjelpetekst

**🏷️ Labels:** `enhancement`, `shell`, `automation`, `linux`
**⚡ Priority:** P1

---

### Issue E9-2 – Create setup.sh for development environment bootstrap

**🎯 Goal:**
Skriv `scripts/setup.sh` som setter opp hele utviklingsmiljøet fra bunnen: virtualenv, avhengigheter, mapper, `.env`-fil.

**💡 Why it matters:**
Et bootstrap-script reduserer onboarding-tid fra timer til minutter. Viser at man tenker på reproduserbarhet og DevOps-kultur.

**📋 Tasks:**
- [ ] Sjekk Python-versjon (krev 3.10+)
- [ ] Opprett `.venv` om den ikke finnes
- [ ] Installer avhengigheter
- [ ] Kopier `.env.example` til `.env` om `.env` mangler
- [ ] Opprett `documents/` og `indexes/` mapper
- [ ] Skriv ut veiledning til slutt (hva gjøres neste)

**✅ Acceptance criteria:**
- `./scripts/setup.sh` fra ren klon setter opp alt uten manuell inngripen
- Script feiler med tydelig feilmelding om Python-versjon er for gammel
- Idempotent: trygt å kjøre flere ganger

**🏷️ Labels:** `enhancement`, `shell`, `automation`, `linux`
**⚡ Priority:** P1

---

### Issue E9-3 – Create ingest.sh script

**🎯 Goal:**
Skriv `scripts/ingest.sh` som trigger ingestion via API-kall og viser fremdrift i terminalen.

**💡 Why it matters:**
Operasjonelle scripts for vanlige oppgaver er standard praksis. Viser praktisk API-bruk fra shell.

**📋 Tasks:**
- [ ] Send `POST /ingest` via `curl`
- [ ] Vis responsstatistikk (antall filer, chunks)
- [ ] Håndter feil (f.eks. app er ikke oppe)
- [ ] Legg til `--host` og `--port`-argumenter

**✅ Acceptance criteria:**
- `./scripts/ingest.sh` trigger ingestion og viser statistikk
- Feil håndteres med tydelig feilmelding
- `--host` og `--port` er støttet

**🏷️ Labels:** `enhancement`, `shell`, `automation`
**⚡ Priority:** P2

---

### Issue E9-4 – Create healthcheck.sh script

**🎯 Goal:**
Skriv `scripts/healthcheck.sh` som sjekker applikasjonens helsetilstand og returnerer exit code 0 (frisk) eller 1 (syk).

**💡 Why it matters:**
Healthcheck-scripts brukes i Docker og systemd for å avgjøre om en tjeneste skal restartes. Viser forståelse for automatisk tjenesteovervåkning.

**📋 Tasks:**
- [ ] Send `GET /health` via curl
- [ ] Parse JSON-respons og sjekk `status`-feltet
- [ ] Returner exit code 0 om status=ok, 1 ellers
- [ ] Legg til timeout-parameter
- [ ] Dokumenter bruk i README

**✅ Acceptance criteria:**
- `./scripts/healthcheck.sh` returnerer exit code 0 om appen er frisk
- Exit code 1 om appen er nede eller syk
- Fungerer som HEALTHCHECK-kommando i Dockerfile

**🏷️ Labels:** `enhancement`, `shell`, `healthcheck`, `linux`
**⚡ Priority:** P2

---

### Issue E9-5 – Create backup.sh for index persistence

**🎯 Goal:**
Skriv `scripts/backup.sh` som tar backup av FAISS-indeksen og dokumentene til en datestemplet tarball.

**💡 Why it matters:**
Backup-rutiner er grunnleggende driftspraksis. Viser at man tenker på dataintegritet og gjenoppretting.

**📋 Tasks:**
- [ ] Opprett backup av `indexes/`-mappen med dato/tid i filnavn
- [ ] Komprimér med `tar -czf`
- [ ] Lagre i `backups/`-mappe (legg til i `.gitignore`)
- [ ] Rydd opp backups eldre enn N dager (konfigurerbart)
- [ ] Logg backup-operasjonen

**✅ Acceptance criteria:**
- `./scripts/backup.sh` oppretter en datestemplet backup
- Gamle backups ryddes automatisk
- `backups/` er i `.gitignore`

**🏷️ Labels:** `enhancement`, `shell`, `automation`, `linux`
**⚡ Priority:** P3

---

## Epic 10: CI Pipeline

### Issue E10-1 – Set up GitHub Actions CI workflow

**🎯 Goal:**
Opprett en enkel GitHub Actions workflow som kjøres på alle pull requests og pushes til main.

**💡 Why it matters:**
CI er hygienisk minimum i ethvert seriøst prosjekt. GitHub Actions er bransjens standard og direkte relevant for DevOps-stillinger.

**📋 Tasks:**
- [ ] Opprett `.github/workflows/ci.yml`
- [ ] Trigger på `push` til main og `pull_request`
- [ ] Sett opp Python og installer avhengigheter
- [ ] Kjør `ruff check .` (linting)
- [ ] Kjør `pytest` (testing)
- [ ] Legg til status-badge i README

**✅ Acceptance criteria:**
- CI kjører automatisk på PR og push
- Failing linting eller test blokkerer merge
- Status-badge vises i README

**🏷️ Labels:** `ci`, `automation`, `repo-hygiene`
**⚡ Priority:** P1

---

### Issue E10-2 – Add linting step with ruff

**🎯 Goal:**
Konfigurer og integrer `ruff` som linter og formatter i CI-pipelinen.

**💡 Why it matters:**
Automatisert linting forhindrer kodestil-diskusjoner i code review og holder kodebasen konsistent.

**📋 Tasks:**
- [ ] Konfigurer ruff i `pyproject.toml`
- [ ] Legg til ruff-steg i CI-workflow
- [ ] Fikse alle eksisterende linting-feil
- [ ] Dokumenter lokal kjøring i CONTRIBUTING.md

**✅ Acceptance criteria:**
- CI feiler om ruff rapporterer feil
- `ruff check .` passerer lokalt
- Dokumentert i CONTRIBUTING.md

**🏷️ Labels:** `ci`, `code-quality`, `python`
**⚡ Priority:** P2

---

### Issue E10-3 – Add pytest unit tests and CI integration

**🎯 Goal:**
Opprett en `tests/`-mappe med enhetstester for kjernelogikken og integrer med CI.

**💡 Why it matters:**
Testing er grunnleggende for softwarekvalitet. Å ha tester som kjøres automatisk viser DevOps-modenhet.

**📋 Tasks:**
- [ ] Opprett `tests/`-mappe med `__init__.py` og `conftest.py`
- [ ] Skriv tester for `chunk_text()`, `load_documents()`, config, `/health`, `/query`
- [ ] Bruk `httpx` og FastAPI `TestClient`
- [ ] Legg til coverage-rapportering med `pytest-cov`
- [ ] Integrer i CI

**✅ Acceptance criteria:**
- `pytest` passerer fra repo-rot
- Dekning er > 60%
- CI feiler ved mislykket test

**🏷️ Labels:** `testing`, `ci`, `python`
**⚡ Priority:** P2

---

### Issue E10-4 – Add Docker build verification in CI

**🎯 Goal:**
Legg til et CI-steg som bygger Docker-imagen for å bekrefte at Dockerfile alltid er i funksjonell tilstand.

**💡 Why it matters:**
Broken Dockerfile oppdages ikke uten å bygge den. CI-verifisering sikrer at imagen alltid kan bygges.

**📋 Tasks:**
- [ ] Legg til `docker build`-steg i CI
- [ ] Legg til enkel smoke test: start container, kjør healthcheck
- [ ] Dokument Docker-steget i README

**✅ Acceptance criteria:**
- CI feiler om Docker build feiler
- Container smoke test (healthcheck) passerer i CI

**🏷️ Labels:** `ci`, `docker`, `automation`
**⚡ Priority:** P2

---

### Issue E10-5 – Add dependency security scanning

**🎯 Goal:**
Legg til automatisk sikkerhetsscanning av Python-avhengigheter med `pip-audit` eller GitHub Dependabot.

**💡 Why it matters:**
Sikkerhets-scanning av avhengigheter er bransjekrav og DevSecOps-praksis. Viser bevissthet om supply chain security.

**📋 Tasks:**
- [ ] Aktiver Dependabot i `.github/dependabot.yml`
- [ ] Legg til `pip-audit`-steg i CI
- [ ] Konfigurer Dependabot for automatiske PR-er ved CVE
- [ ] Dokumenter sikkerhetsrutiner i CONTRIBUTING.md

**✅ Acceptance criteria:**
- Dependabot oppretter PR ved sårbare avhengigheter
- `pip-audit` kjøres i CI
- CONTRIBUTING.md dokumenterer sikkerhetsrapportering

**🏷️ Labels:** `ci`, `security`, `automation`
**⚡ Priority:** P3

---

## Epic 11: Reverse Proxy & Networking

### Issue E11-1 – Add nginx configuration for API proxy

**🎯 Goal:**
Opprett en nginx-konfigurasjon som fungerer som reverse proxy foran FastAPI-appen.

**💡 Why it matters:**
Reverse proxy er standard i produksjonsoppsett for å håndtere TLS, rate limiting og statisk innhold. Nginx er det vanligste valget.

**📋 Tasks:**
- [ ] Opprett `nginx/nginx.conf`
- [ ] Konfigurer proxy_pass til FastAPI-tjenesten
- [ ] Sett fornuftige timeouts og headers
- [ ] Videresend `X-Forwarded-For` og `X-Real-IP`

**✅ Acceptance criteria:**
- nginx proxyer kall til FastAPI korrekt
- Headers videresendes

**🏷️ Labels:** `enhancement`, `nginx`, `infra`, `networking`
**⚡ Priority:** P2

---

### Issue E11-2 – Integrate nginx service in docker-compose

**🎯 Goal:**
Legg til nginx som en service i `docker-compose.yml` foran FastAPI-appen.

**💡 Why it matters:**
Et docker-compose oppsett med nginx og app er et klassisk produksjonsoppsett som er direkte overførbart til Kubernetes.

**📋 Tasks:**
- [ ] Legg til `nginx`-service i `docker-compose.yml`
- [ ] Map port 80 (nginx) fremfor 8000 (app direkte)
- [ ] Koble nginx til app via internt Docker-nettverk
- [ ] Oppdater README med ny port og oppsett

**✅ Acceptance criteria:**
- `docker-compose up` starter både nginx og app
- API er tilgjengelig på port 80 via nginx
- App er ikke direkte tilgjengelig utenfra

**🏷️ Labels:** `enhancement`, `nginx`, `docker`, `networking`
**⚡ Priority:** P2

---

### Issue E11-3 – Configure rate limiting in nginx

**🎯 Goal:**
Konfigurer rate limiting i nginx for å begrense antall forespørsler per IP per sekund.

**💡 Why it matters:**
Rate limiting beskytter tjenesten mot misbruk og overbelastning – et viktig driftsmessig hensyn.

**📋 Tasks:**
- [ ] Legg til `limit_req_zone` og `limit_req` i nginx.conf
- [ ] Sett grense for `/query`-endepunktet (f.eks. 10 req/s)
- [ ] Returner 429 ved for mange forespørsler
- [ ] Test med `ab` eller `curl`-loop

**✅ Acceptance criteria:**
- Over-grensen forespørsler returnerer 429
- Grense er konfigurerbar i nginx.conf

**🏷️ Labels:** `enhancement`, `nginx`, `security`, `networking`
**⚡ Priority:** P3

---

### Issue E11-4 – Document SSL/TLS setup with self-signed certificate

**🎯 Goal:**
Dokumenter og skriv script for å sette opp SSL med selvsignert sertifikat for lokal utvikling.

**💡 Why it matters:**
Selv om prod-TLS håndteres av Certbot/Let's Encrypt, viser kunnskap om sertifikater og HTTPS-oppsett grunnleggende sikkerhetsforståelse.

**📋 Tasks:**
- [ ] Skriv `scripts/generate-certs.sh` med `openssl`-kommandoer
- [ ] Oppdater nginx.conf med SSL-konfigurasjon
- [ ] Legg til `certs/` i `.gitignore`
- [ ] Dokumenter i README

**✅ Acceptance criteria:**
- `./scripts/generate-certs.sh` genererer self-signed cert
- HTTPS fungerer lokalt på port 443
- Sertifikatfiler er i `.gitignore`

**🏷️ Labels:** `documentation`, `security`, `nginx`, `linux`
**⚡ Priority:** P3

---

## Epic 12: Kubernetes/OpenShift-Inspired Structure

### Issue E12-1 – Create k8s/ directory with Deployment manifest

**🎯 Goal:**
Opprett en `k8s/`-mappe med Kubernetes Deployment-manifest for applikasjonen.

**💡 Why it matters:**
Selv om vi ikke deployer til Kubernetes ennå, viser manifest-strukturen forståelse for container-orchestrering og gjør fremtidig migrasjon enkel.

**📋 Tasks:**
- [ ] Opprett `k8s/`-mappe
- [ ] Skriv `k8s/deployment.yaml` med korrekte ressursgrenser
- [ ] Bruk `imagePullPolicy: IfNotPresent` for lokal utvikling
- [ ] Sett `replicas: 1`
- [ ] Legg til liveness og readiness probes

**✅ Acceptance criteria:**
- `kubectl apply -f k8s/deployment.yaml` fungerer (om kubectl er installert)
- Liveness og readiness probes peker på `/health` og `/ready`

**🏷️ Labels:** `enhancement`, `kubernetes`, `infra`
**⚡ Priority:** P3

---

### Issue E12-2 – Add ConfigMap and Secret templates

**🎯 Goal:**
Opprett Kubernetes ConfigMap og Secret-templates for applikasjonskonfigurasjon.

**💡 Why it matters:**
ConfigMaps og Secrets er Kubernetes-måten å håndtere konfigurasjon på – direkte analog til Docker env-vars og volumes.

**📋 Tasks:**
- [ ] Opprett `k8s/configmap.yaml` med ikke-hemmelige konfigurasjoner
- [ ] Opprett `k8s/secret.yaml.example` (aldri ekte verdier)
- [ ] Oppdater Deployment til å bruke ConfigMap
- [ ] Dokumenter i README

**✅ Acceptance criteria:**
- ConfigMap og Secret templates finnes
- Deployment bruker ConfigMap
- Ingen ekte secrets i `secret.yaml`

**🏷️ Labels:** `enhancement`, `kubernetes`, `config`
**⚡ Priority:** P3

---

### Issue E12-3 – Add Service and Ingress manifests

**🎯 Goal:**
Skriv Kubernetes Service og Ingress-manifest for å eksponere appen eksternt.

**💡 Why it matters:**
Service og Ingress er Kubernetes-alternativet til nginx reverse proxy i docker-compose. Viser bredde i infrastruktur-kunnskap.

**📋 Tasks:**
- [ ] Opprett `k8s/service.yaml` (ClusterIP)
- [ ] Opprett `k8s/ingress.yaml` med nginx ingress class
- [ ] Dokumenter i README

**✅ Acceptance criteria:**
- Service og Ingress manifest finnes og er syntaktisk korrekte
- Dokumentert i README

**🏷️ Labels:** `enhancement`, `kubernetes`, `networking`
**⚡ Priority:** P3

---

### Issue E12-4 – Add PersistentVolumeClaim for document storage

**🎯 Goal:**
Legg til PVC-manifest for persistent lagring av dokumenter og indekser i Kubernetes.

**💡 Why it matters:**
PVCs er Kubernetes-ekvivalenten til Docker bind-mounts. Viser forståelse for persistent storage i orchestrerte miljøer.

**📋 Tasks:**
- [ ] Opprett `k8s/pvc.yaml` for documents og indexes
- [ ] Oppdater Deployment til å mounte PVC
- [ ] Dokumenter i README

**✅ Acceptance criteria:**
- PVC manifest finnes
- Deployment refererer PVC korrekt
- Dokumentert

**🏷️ Labels:** `enhancement`, `kubernetes`, `storage`
**⚡ Priority:** P3

---

## Prioritert Gjøre-rekkefølge

### Fase 1 – Fundament (Sprint 1)
1. **E1-1** – pyproject.toml
2. **E1-2** – README
3. **E2-1** – Fix ingestion bug
4. **E5-1** – Pydantic BaseSettings
5. **E5-2** – .env.example dokumentasjon
6. **E6-1** – Strukturert logging
7. **E6-2** – Request/response middleware

### Fase 2 – Kjernefeature (Sprint 2)
8. **E2-2** – Filformat-støtte
9. **E2-3** – Chunking med overlapp
10. **E3-1** – sentence-transformers
11. **E3-2** – FAISS vector store
12. **E3-3** – Indekserings-pipeline
13. **E4-1** – Semantisk søk

### Fase 3 – Drift & Docker (Sprint 3)
14. **E8-1** – Dockerfile
15. **E8-2** – .dockerignore
16. **E8-3** – docker-compose
17. **E8-4** – Volume mounts
18. **E9-1** – start.sh / stop.sh
19. **E9-2** – setup.sh
20. **E7-1** – Utvidet /health

### Fase 4 – Robusthet & CI (Sprint 4)
21. **E4-2** – Query validering
22. **E6-3** – Global exception handler
23. **E9-3** – ingest.sh
24. **E9-4** – healthcheck.sh
25. **E10-1** – GitHub Actions CI
26. **E10-2** – Linting i CI
27. **E10-3** – pytest i CI

### Fase 5 – Infrastruktur (Sprint 5+)
28. **E11-1** – nginx konfigurasjon
29. **E11-2** – nginx i docker-compose
30. **E12-1** – Kubernetes Deployment
31. **E12-2** – ConfigMap / Secret

---

*Sist oppdatert: 2026-03-30*
