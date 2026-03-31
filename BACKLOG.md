# Backlog – Eksamen RAG

Alle issues er delt inn i epics (temagrupper). Kjør `scripts/create-issues.sh` for å laste dem opp til GitHub slik at du kan se dem og lage branches fra dem.

---

## Epic 1 – Prosjektstruktur og repo-hygiene
| # | Tittel | Prioritet |
|---|--------|-----------|
| E1-1 | Bytt requirements.txt med pyproject.toml | P1 |
| E1-2 | Skriv en skikkelig README | P1 |
| E1-3 | Legg til CONTRIBUTING.md | P2 |
| E1-4 | Sett opp ruff for linting og .editorconfig | P2 |

## Epic 2 – Dokument-ingestion
| # | Tittel | Prioritet |
|---|--------|-----------|
| E2-1 | 🐛 Fiks syntaksfeil og fullfør ingest_documents() | **P0** |
| E2-2 | Støtt .txt, .md og .pdf filer | P1 |
| E2-3 | Konfigurerbar chunk-størrelse og overlapp | P1 |
| E2-4 | Legg til POST /ingest API-endepunkt | P2 |
| E2-5 | Idempotent ingestion (hopp over uendrede filer) | P3 |

## Epic 3 – Embeddings og vektorlagring
| # | Tittel | Prioritet |
|---|--------|-----------|
| E3-1 | Integrer sentence-transformers for lokale embeddings | P1 |
| E3-2 | Sett opp FAISS som lokal vektordatabase | P1 |
| E3-3 | Koble ingestion → embedding → FAISS i én pipeline | P1 |
| E3-4 | Lagre og last FAISS-indeksen fra disk | P2 |
| E3-5 | Legg til GET /index/status endepunkt | P2 |

## Epic 4 – Søk og query-API
| # | Tittel | Prioritet |
|---|--------|-----------|
| E4-1 | Implementer semantisk søk med FAISS | P1 |
| E4-2 | Validering og feilhåndtering på /query | P2 |
| E4-3 | Resultatrangering og kontekstvindu | P3 |
| E4-4 | Legg til POST /query for lange søk | P3 |

## Epic 5 – Konfigurasjon og miljøvariabler
| # | Tittel | Prioritet |
|---|--------|-----------|
| E5-1 | Migrer til Pydantic BaseSettings | P1 |
| E5-2 | Dokumenter alle miljøvariabler i .env.example | P1 |
| E5-3 | Valider kritisk konfigurasjon ved oppstart | P2 |
| E5-4 | Produksjonsmodus med strengere innstillinger | P2 |

## Epic 6 – Logging og feilhåndtering
| # | Tittel | Prioritet |
|---|--------|-----------|
| E6-1 | Strukturert JSON-logging i produksjon | P1 |
| E6-2 | Request/response logging middleware | P1 |
| E6-3 | Global exception handler | P2 |
| E6-4 | Correlation ID på alle forespørsler | P3 |
| E6-5 | Logg-rotasjon til fil | P3 |

## Epic 7 – Healthcheck og observability
| # | Tittel | Prioritet |
|---|--------|-----------|
| E7-1 | Utvid /health med systemsjekker | P1 |
| E7-2 | Legg til /ready readiness probe | P2 |
| E7-3 | Legg til uptime og diskplass i health-respons | P2 |
| E7-4 | Enkelt /metrics endepunkt | P3 |

## Epic 8 – Docker og containerisering
| # | Tittel | Prioritet |
|---|--------|-----------|
| E8-1 | Lag Dockerfile med multi-stage build | P1 |
| E8-2 | Lag .dockerignore | P1 |
| E8-3 | Lag docker-compose.yml | P1 |
| E8-4 | Konfigurerbar volum-mount for dokumenter og indekser | P2 |
| E8-5 | Dokumenter alle Docker miljøvariabler | P2 |

## Epic 9 – Shell scripts og automatisering
| # | Tittel | Prioritet |
|---|--------|-----------|
| E9-1 | Lag start.sh og stop.sh | P1 |
| E9-2 | Lag setup.sh for å sette opp utviklingsmiljøet | P1 |
| E9-3 | Lag ingest.sh for å trigge ingestion via API | P2 |
| E9-4 | Lag healthcheck.sh som returnerer exit code | P2 |
| E9-5 | Lag backup.sh for sikkerhetskopiering av indeks | P3 |

## Epic 10 – CI pipeline
| # | Tittel | Prioritet |
|---|--------|-----------|
| E10-1 | Sett opp GitHub Actions CI workflow | P1 |
| E10-2 | Legg til linting med ruff i CI | P2 |
| E10-3 | Legg til pytest og testdekning i CI | P2 |
| E10-4 | Verifiser Docker build i CI | P2 |
| E10-5 | Sikkerhetsskanning av avhengigheter | P3 |

## Epic 11 – Reverse proxy og nettverk
| # | Tittel | Prioritet |
|---|--------|-----------|
| E11-1 | Nginx-konfigurasjon som reverse proxy | P2 |
| E11-2 | Integrer nginx i docker-compose | P2 |
| E11-3 | Rate limiting i nginx | P3 |
| E11-4 | Dokumenter SSL/TLS oppsett med self-signed sertifikat | P3 |

## Epic 12 – Kubernetes-inspirert struktur
| # | Tittel | Prioritet |
|---|--------|-----------|
| E12-1 | Lag k8s/ mappe med Deployment manifest | P3 |
| E12-2 | Legg til ConfigMap og Secret templates | P3 |
| E12-3 | Legg til Service og Ingress manifester | P3 |
| E12-4 | Legg til PersistentVolumeClaim for dokumentlagring | P3 |

---

**Prioritetsforklaring:**
- **P0** = Kritisk bugfix, gjøres umiddelbart
- **P1** = Gjøres i sprint 1
- **P2** = Gjøres i sprint 2–3
- **P3** = Gjøres seinere / nice-to-have
