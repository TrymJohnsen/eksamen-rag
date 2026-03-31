# Eksamen RAG

Lokal dokumenttjeneste med AI-søk, bygget med FastAPI + FAISS + sentence-transformers.

---

## Kjør applikasjonen lokalt

```bash
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Applikasjonen er da tilgjengelig på `http://localhost:8000`.

### API-endepunkter

| Metode | URL | Beskrivelse |
|--------|-----|-------------|
| GET | `/` | Statusmelding |
| GET | `/health` | Helsesjekk |
| GET | `/query?q=<tekst>` | Søk i dokumenter |

---

## Opprett GitHub Issues fra backloggen

Se [BACKLOG.md](BACKLOG.md) for full oversikt over alle planlagte issues (54 issues fordelt på 12 epics).

For å laste dem opp til GitHub slik at du kan se dem og lage branches fra dem:

```bash
# 1. Installer GitHub CLI (https://cli.github.com) – én gang
gh auth login

# 2. Kjør scriptet
./scripts/create-issues.sh TrymJohnsen/eksamen-rag
```

Etter dette dukker alle issues opp under **Issues**-fanen i GitHub, og du kan klikke
"Create a branch" på hvert issue for å begynne å jobbe med dem.

---

## Miljøvariabler

Kopier `.env.example` til `.env` og tilpass:

```bash
cp .env.example .env
``` 