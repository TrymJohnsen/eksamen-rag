#!/usr/bin/env bash
# =============================================================================
# create-issues.sh – Create GitHub backlog issues for eksamen-rag
#
# Usage:
#   ./scripts/create-issues.sh [--repo OWNER/REPO] [--dry-run]
#
# Requirements:
#   - GitHub CLI (gh) installed and authenticated: gh auth login
#   - Sufficient repository permissions (write access)
#
# Options:
#   --repo OWNER/REPO   Target repository (default: TrymJohnsen/eksamen-rag)
#   --dry-run           Print issues without creating them
#   --labels-only       Only create labels, skip issues
#   --help              Show this help message
# =============================================================================
set -euo pipefail

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
REPO="${REPO:-}"
DRY_RUN=false
LABELS_ONLY=false

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    --repo)       REPO="$2"; shift 2 ;;
    --dry-run)    DRY_RUN=true; shift ;;
    --labels-only) LABELS_ONLY=true; shift ;;
    --help)
      sed -n '/^# Usage/,/^# ====/p' "$0" | sed 's/^# \?//'
      exit 0
      ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

# ---------------------------------------------------------------------------
# Helper functions
# ---------------------------------------------------------------------------
log()   { echo "[$(date '+%H:%M:%S')] $*"; }
error() { echo "[ERROR] $*" >&2; exit 1; }

gh_create_label() {
  local name="$1" color="$2" description="$3"
  if $DRY_RUN; then
    log "DRY-RUN: create label '$name' (#${color})"
    return
  fi
  # Create or update label (ignore error if already exists)
  gh label create "$name" --color "$color" --description "$description" \
    --repo "$REPO" 2>/dev/null || \
  gh label edit "$name"   --color "$color" --description "$description" \
    --repo "$REPO" 2>/dev/null || \
  log "  Label '$name' already exists - skipping"
}

gh_create_issue() {
  local title="$1" body="$2" labels="$3"
  if $DRY_RUN; then
    log "DRY-RUN: create issue '$title'"
    log "  labels: $labels"
    return
  fi

  # Convert comma-separated labels to --label flags
  local label_flags=""
  IFS=',' read -ra LABEL_ARR <<< "$labels"
  for lbl in "${LABEL_ARR[@]}"; do
    label_flags="$label_flags --label $(echo "$lbl" | xargs)"
  done

  # shellcheck disable=SC2086
  gh issue create \
    --repo "$REPO" \
    --title "$title" \
    --body "$body" \
    $label_flags
}

# ---------------------------------------------------------------------------
# Verify gh CLI is available and authenticated
# ---------------------------------------------------------------------------
if [[ -z "$REPO" ]]; then
  error "Repository not specified. Use --repo OWNER/REPO or set the REPO environment variable.
  Example: ./scripts/create-issues.sh --repo TrymJohnsen/eksamen-rag"
fi

if ! command -v gh &>/dev/null; then
  error "GitHub CLI (gh) is not installed. Install from https://cli.github.com"
fi

if ! $DRY_RUN; then
  if ! gh auth status --hostname github.com &>/dev/null; then
    error "Not authenticated. Run: gh auth login"
  fi
fi

log "Target repository: $REPO"
$DRY_RUN    && log "Mode: DRY RUN (no changes will be made)"
$LABELS_ONLY && log "Mode: Labels only"

# ===========================================================================
# STEP 1 – Create labels
# ===========================================================================
log "Creating labels..."

# Format: gh_create_label "name" "hex-color-without-hash" "description"
gh_create_label "enhancement"   "a2eeef" "New feature or improvement"
gh_create_label "bug"           "d73a4a" "Something isn't working"
gh_create_label "documentation" "0075ca" "Improvements or additions to documentation"
gh_create_label "repo-hygiene"  "e4e669" "Repository structure and code quality"
gh_create_label "python"        "3572A5" "Python language related"
gh_create_label "api"           "1d76db" "API endpoints and design"
gh_create_label "ingestion"     "f9d0c4" "Document ingestion pipeline"
gh_create_label "embeddings"    "bfd4f2" "Embedding model and vector representation"
gh_create_label "vector-store"  "c5def5" "FAISS and vector storage"
gh_create_label "ai"            "d4c5f9" "Artificial intelligence components"
gh_create_label "search"        "fef2c0" "Search and retrieval logic"
gh_create_label "config"        "f0e68c" "Configuration and environment management"
gh_create_label "logging"       "b60205" "Logging and structured output"
gh_create_label "error-handling" "e11d48" "Exception handling and error responses"
gh_create_label "observability" "0e8a16" "Metrics, tracing, and monitoring"
gh_create_label "healthcheck"   "006b75" "Health and readiness probes"
gh_create_label "metrics"       "208080" "Application metrics"
gh_create_label "docker"        "0db7ed" "Docker and containerization"
gh_create_label "infra"         "5319e7" "Infrastructure and deployment"
gh_create_label "storage"       "795548" "Persistent storage and volumes"
gh_create_label "shell"         "ff9800" "Shell scripts and automation"
gh_create_label "automation"    "ff5722" "Automation tooling"
gh_create_label "linux"         "795548" "Linux and OS-level tasks"
gh_create_label "ci"            "2cbe4e" "Continuous Integration"
gh_create_label "code-quality"  "e4e669" "Code style and quality tools"
gh_create_label "testing"       "0e8a16" "Automated testing"
gh_create_label "security"      "b60205" "Security and access control"
gh_create_label "performance"   "e99695" "Performance improvements"
gh_create_label "persistence"   "bfd4f2" "Data persistence"
gh_create_label "operational"   "1d76db" "Operational readiness"
gh_create_label "nginx"         "009900" "Nginx reverse proxy"
gh_create_label "networking"    "4a90d9" "Network and connectivity"
gh_create_label "kubernetes"    "326ce5" "Kubernetes / OpenShift"

log "Labels done."

$LABELS_ONLY && { log "Labels-only mode – exiting."; exit 0; }

# ===========================================================================
# STEP 2 – Create issues
# ===========================================================================
log "Creating issues..."

# ---------------------------------------------------------------------------
# EPIC 1 – Project Foundation & Repo Hygiene
# ---------------------------------------------------------------------------
gh_create_issue \
  "[E1-1] Initialize Python project with pyproject.toml" \
  "## 🎯 Goal
Replace the simple \`requirements.txt\` with a modern \`pyproject.toml\` that defines dependencies, the Python version, and project metadata.

## 💡 Why it matters
\`pyproject.toml\` is standard in modern Python projects. It makes it easier to manage versions, build packages, and integrate with linters and CI tools. It also signals Python competence beyond the basics.

## 📋 Tasks
- [ ] Create \`pyproject.toml\` with a \`[project]\` section (name, version, Python requirement)
- [ ] Move dependencies from \`requirements.txt\` to \`[project.dependencies]\`
- [ ] Add dev dependencies (\`pytest\`, \`ruff\`, \`httpx\`) under \`[project.optional-dependencies]\`
- [ ] Keep \`requirements.txt\` generated via \`pip freeze\` for Docker backward-compat
- [ ] Update README with new install instructions

## ✅ Acceptance criteria
- \`pip install -e \".[dev]\"\` works without errors
- \`pyproject.toml\` is the single source of truth for dependencies
- CI pipeline can consume \`pyproject.toml\`

## ⚡ Priority
P1 – Do first" \
  "enhancement,repo-hygiene,python"

gh_create_issue \
  "[E1-2] Set up comprehensive README" \
  "## 🎯 Goal
Write a README that explains the project, architecture, how to run it locally and with Docker, and what each component does.

## 💡 Why it matters
A good README is the first thing a technical interviewer sees. It signals tidiness, documentation culture, and that you care about others' experience – key qualities for an operations role.

## 📋 Tasks
- [ ] Add project description and goals
- [ ] Document architecture diagram (text or ASCII art)
- [ ] Add Quick Start (local run)
- [ ] Add Docker Quick Start
- [ ] Document all API endpoints with example curl calls
- [ ] Add sections: Prerequisites, Environment Variables, Project Structure

## ✅ Acceptance criteria
- A new developer can set up and run the project just by following the README
- All API endpoints are documented with examples

## ⚡ Priority
P1 – Do early" \
  "documentation,repo-hygiene"

gh_create_issue \
  "[E1-3] Add CONTRIBUTING.md and development setup guide" \
  "## 🎯 Goal
Document the process for contributing to the project: branch naming, commit conventions, local setup and PR process.

## 💡 Why it matters
Shows professional thinking around teamwork and repo hygiene. Important for DevOps roles where process discipline and documentation are expected.

## 📋 Tasks
- [ ] Create \`CONTRIBUTING.md\`
- [ ] Describe branch naming (\`feature/\`, \`fix/\`, \`infra/\`)
- [ ] Describe commit message convention (Conventional Commits)
- [ ] Document local dev setup (virtualenv, \`.env\` file)
- [ ] Describe the PR process

## ✅ Acceptance criteria
- \`CONTRIBUTING.md\` exists and is readable
- Conventions are consistent with existing commits

## ⚡ Priority
P2" \
  "documentation,repo-hygiene"

gh_create_issue \
  "[E1-4] Add .editorconfig and ruff code style configuration" \
  "## 🎯 Goal
Add \`.editorconfig\` and \`ruff\` configuration in \`pyproject.toml\` so the entire project follows consistent code style.

## 💡 Why it matters
Consistent formatting reduces diff noise, makes code review easier, and signals that you work professionally. Ruff is modern and fast – used in enterprise Python projects.

## 📋 Tasks
- [ ] Create \`.editorconfig\` (indentation, line endings, charset)
- [ ] Add \`[tool.ruff]\` section to \`pyproject.toml\`
- [ ] Configure ruff rules (E, F, I, UP minimum)
- [ ] Run \`ruff format .\` and fix existing style issues
- [ ] Document running the linter in README

## ✅ Acceptance criteria
- \`ruff check .\` passes with no errors
- \`.editorconfig\` is in place

## ⚡ Priority
P2" \
  "repo-hygiene,code-quality,python"

# ---------------------------------------------------------------------------
# EPIC 2 – Document Ingestion Pipeline
# ---------------------------------------------------------------------------
gh_create_issue \
  "[E2-1] Fix and complete the ingest_documents() function" \
  "## 🎯 Goal
Fix the incomplete \`ingest_documents()\` function in \`app/services/ingestion.py\` which contains a syntax error and missing implementation.

## 💡 Why it matters
Ingestion is the foundation of the entire RAG pipeline. Without working ingestion, the system cannot index documents and search will never work.

## 📋 Tasks
- [ ] Fix syntax error on line 40 (dangling variable \`f\`)
- [ ] Complete the loop to collect all chunks from all documents
- [ ] Return list of \`{filename, chunk_index, content}\` per chunk
- [ ] Add error handling for files that cannot be read
- [ ] Write a simple unit test for \`ingest_documents()\`

## ✅ Acceptance criteria
- \`ingest_documents()\` returns a list of chunks
- Syntax error is gone
- Errors in individual files do not stop ingestion of the rest
- Unit test passes

## ⚡ Priority
P0 – Critical bugfix" \
  "bug,ingestion,python"

gh_create_issue \
  "[E2-2] Support multiple document formats (.txt, .md, .pdf)" \
  "## 🎯 Goal
Extend \`load_documents()\` to support \`.txt\`, \`.md\`, and \`.pdf\` files (PDF via \`pypdf\`).

## 💡 Why it matters
Real document services must handle varied file formats. Shows that you think about actual use cases, not just the happy path.

## 📋 Tasks
- [ ] Add \`pypdf\` to dependencies
- [ ] Implement \`read_pdf(filepath)\` function
- [ ] Update \`load_documents()\` to route based on file type
- [ ] Handle encoding errors for text files
- [ ] Log which files are skipped (unknown format)
- [ ] Test with a \`.txt\`, \`.md\`, and \`.pdf\` in \`documents/\`

## ✅ Acceptance criteria
- \`.txt\`, \`.md\`, and \`.pdf\` files are read correctly
- Unknown file types are logged and skipped
- Unit tests cover all three file types

## ⚡ Priority
P1" \
  "enhancement,ingestion,python"

gh_create_issue \
  "[E2-3] Implement text chunking with configurable size and overlap" \
  "## 🎯 Goal
Improve \`chunk_text()\` to support configurable chunk size and overlap between chunks.

## 💡 Why it matters
Overlapping chunks improve search quality by avoiding important context being cut mid-sentence. Configurability via env variables demonstrates understanding of 12-factor app principles.

## 📋 Tasks
- [ ] Add \`chunk_overlap\` parameter to \`chunk_text()\`
- [ ] Add \`CHUNK_SIZE\` and \`CHUNK_OVERLAP\` to \`Settings\`
- [ ] Update \`.env.example\` with new variables
- [ ] Write unit tests for chunking with and without overlap
- [ ] Validate that \`chunk_overlap < chunk_size\`

## ✅ Acceptance criteria
- Chunks overlap by the configured number of characters
- Chunk size and overlap are configurable via env
- Unit tests pass
- \`.env.example\` is updated

## ⚡ Priority
P1" \
  "enhancement,ingestion,config"

gh_create_issue \
  "[E2-4] Add POST /ingest API endpoint" \
  "## 🎯 Goal
Add a \`POST /ingest\` endpoint that triggers ingestion of all documents in \`DOCUMENTS_PATH\` and returns a summary.

## 💡 Why it matters
Makes ingestion triggerable via API, which is necessary for automation and CI/CD integration. Demonstrates RESTful API design.

## 📋 Tasks
- [ ] Add \`POST /ingest\` to \`app/api/routes.py\`
- [ ] Return \`{status, files_processed, chunks_created, duration_ms}\`
- [ ] Handle errors with appropriate HTTP status codes
- [ ] Log start and end of ingestion with timing
- [ ] Test the endpoint with \`curl\`

## ✅ Acceptance criteria
- \`POST /ingest\` returns 200 with statistics
- Errors return 500 with descriptive error message
- Ingestion is logged with duration

## ⚡ Priority
P2" \
  "enhancement,ingestion,api"

gh_create_issue \
  "[E2-5] Add ingestion idempotency and change detection" \
  "## 🎯 Goal
Avoid re-ingesting documents that have not changed since the last run by storing file hashes.

## 💡 Why it matters
Important for performance and operational efficiency. Shows understanding of stateful systems and idempotent operations – a core DevOps theme.

## 📋 Tasks
- [ ] Store MD5 hash per file in a simple JSON file
- [ ] Check hash on re-ingest – skip unchanged files
- [ ] Add \`force=true\` parameter to force full re-ingestion
- [ ] Log which files were skipped

## ✅ Acceptance criteria
- Unchanged files are not re-ingested
- \`POST /ingest?force=true\` forces full re-ingestion
- Changed file is detected and re-ingested

## ⚡ Priority
P3" \
  "enhancement,ingestion,performance"

# ---------------------------------------------------------------------------
# EPIC 3 – Embeddings & Vector Store
# ---------------------------------------------------------------------------
gh_create_issue \
  "[E3-1] Integrate sentence-transformers for local embeddings" \
  "## 🎯 Goal
Integrate the \`sentence-transformers\` library to generate local vector representations (embeddings) of text chunks.

## 💡 Why it matters
Local embeddings are the core of a local-first RAG solution. No external API required – everything runs offline. Demonstrates understanding of ML infrastructure.

## 📋 Tasks
- [ ] Add \`sentence-transformers\` to dependencies
- [ ] Create \`app/services/embeddings.py\`
- [ ] Implement \`get_embedding(text: str) -> list[float]\`
- [ ] Add \`EMBEDDING_MODEL\` to \`Settings\` (default: \`all-MiniLM-L6-v2\`)
- [ ] Implement lazy loading of model (load on first call)
- [ ] Log which model is being loaded

## ✅ Acceptance criteria
- \`get_embedding(\"test\")\` returns a list of floats
- Model name is configurable via env
- Model is loaded only once per startup

## ⚡ Priority
P1" \
  "enhancement,embeddings,ai"

gh_create_issue \
  "[E3-2] Set up FAISS local vector store" \
  "## 🎯 Goal
Integrate FAISS as the local vector database for storing and searching embeddings.

## 💡 Why it matters
FAISS is the standard for local vector search – used in production systems at Meta and many others. Demonstrates concrete knowledge of AI infrastructure tooling.

## 📋 Tasks
- [ ] Add \`faiss-cpu\` to dependencies
- [ ] Create \`app/services/vector_store.py\`
- [ ] Implement \`VectorStore\` class with \`add()\` and \`search()\` methods
- [ ] Store metadata (filename, chunk_index) separately as a list parallel to the FAISS index
- [ ] Write unit tests for add and search

## ✅ Acceptance criteria
- \`VectorStore.add(embedding, metadata)\` adds a vector
- \`VectorStore.search(embedding, k=5)\` returns top-k results
- Unit tests pass

## ⚡ Priority
P1" \
  "enhancement,vector-store,ai"

gh_create_issue \
  "[E3-3] Implement end-to-end indexing pipeline" \
  "## 🎯 Goal
Connect ingestion → chunking → embedding → FAISS into a cohesive indexing pipeline.

## 💡 Why it matters
Pipeline thinking is central to DevOps. Demonstrates the ability to connect components into a working system.

## 📋 Tasks
- [ ] Create \`app/services/indexer.py\`
- [ ] Implement \`build_index()\` that runs the full pipeline
- [ ] Integrate with the \`POST /ingest\` endpoint
- [ ] Log progress: number of chunks processed
- [ ] Measure and log total indexing time

## ✅ Acceptance criteria
- \`build_index()\` produces a FAISS index from documents in \`DOCUMENTS_PATH\`
- \`POST /ingest\` calls \`build_index()\` and returns statistics
- Progress is logged

## ⚡ Priority
P1" \
  "enhancement,ingestion,embeddings,ai"

gh_create_issue \
  "[E3-4] Persist FAISS index to disk" \
  "## 🎯 Goal
Save the FAISS index to disk so it survives container restarts, and load it automatically on startup.

## 💡 Why it matters
Persistence is a fundamental operations principle. Demonstrates understanding of stateful services, Docker volume mounts, and graceful startup.

## 📋 Tasks
- [ ] Implement \`save_index(path)\` and \`load_index(path)\` in \`VectorStore\`
- [ ] Use \`INDEX_PATH\` from \`Settings\`
- [ ] Load existing index on application startup in \`main.py\`
- [ ] Log whether index was loaded from disk or starts empty
- [ ] Handle corrupt index file with error message and empty startup

## ✅ Acceptance criteria
- Index is saved to \`INDEX_PATH\` after \`build_index()\`
- Index is loaded automatically on startup
- Corrupt file gives a log warning, not a crash

## ⚡ Priority
P2" \
  "enhancement,vector-store,persistence"

gh_create_issue \
  "[E3-5] Add GET /index/status endpoint" \
  "## 🎯 Goal
Add an endpoint that returns the status of the FAISS index: vector count, model, last updated.

## 💡 Why it matters
Operational visibility is important for operations. Shows that you think about observability beyond just health checks.

## 📋 Tasks
- [ ] Add \`GET /index/status\` to routes
- [ ] Return \`{vector_count, embedding_model, last_indexed, index_size_bytes}\`
- [ ] Return 204 if index does not exist yet

## ✅ Acceptance criteria
- \`GET /index/status\` returns correct info
- 204 returned if index has not been built

## ⚡ Priority
P2" \
  "enhancement,api,observability"

# ---------------------------------------------------------------------------
# EPIC 4 – Query & Search API
# ---------------------------------------------------------------------------
gh_create_issue \
  "[E4-1] Implement semantic search using FAISS" \
  "## 🎯 Goal
Implement actual semantic search in \`run_query()\` using embeddings + FAISS.

## 💡 Why it matters
This is the core feature of the entire RAG system. All work in Epic 2 and 3 converges here.

## 📋 Tasks
- [ ] Update \`run_query()\` to call \`get_embedding()\` on the query
- [ ] Search the FAISS index with the query embedding
- [ ] Return the top-k most relevant chunks with metadata
- [ ] Add \`k\` parameter to query (default: 5)

## ✅ Acceptance criteria
- \`GET /query?q=<text>\` returns relevant chunks
- Results include \`filename\`, \`chunk_index\`, \`score\`, and \`content\`
- k is configurable

## ⚡ Priority
P1" \
  "enhancement,search,ai"

gh_create_issue \
  "[E4-2] Add query validation and error handling" \
  "## 🎯 Goal
Robust validation of the query parameter with clear error messages and correct HTTP status codes.

## 💡 Why it matters
Error handling is one of the first things a code reviewer looks at. Demonstrates professional API design.

## 📋 Tasks
- [ ] Validate that \`q\` is not empty (already done – verify and test)
- [ ] Return 503 if index has not been built
- [ ] Return 200 with empty result list if no hits
- [ ] Add \`MAX_QUERY_LENGTH\` to config and validate
- [ ] Handle exceptions in search with 500 error and log

## ✅ Acceptance criteria
- Empty query → 400
- Index not built → 503 with descriptive message
- No hits → 200 with \`results: []\`
- Unhandled exception → 500 with log

## ⚡ Priority
P2" \
  "enhancement,api,error-handling"

gh_create_issue \
  "[E4-3] Add result ranking and context window" \
  "## 🎯 Goal
Return results with score-based ranking and include neighboring chunks as a contextual window.

## 💡 Why it matters
Context windows improve answer quality and are standard in RAG implementations.

## 📋 Tasks
- [ ] Sort results by cosine similarity score (highest first)
- [ ] Add option to return chunk ± 1 neighbors as context
- [ ] Add \`include_context=true\` parameter
- [ ] Test that relevant chunks rank highest

## ✅ Acceptance criteria
- Results are sorted with the best match first
- \`include_context=true\` returns context chunks
- Score is normalized between 0 and 1

## ⚡ Priority
P3" \
  "enhancement,search,ai"

gh_create_issue \
  "[E4-4] Add POST /query endpoint for longer queries" \
  "## 🎯 Goal
Add a \`POST /query\` with a JSON body to support queries longer than URL limits allow.

## 💡 Why it matters
Professional API design has POST endpoints for search with long or structured requests.

## 📋 Tasks
- [ ] Create Pydantic model \`QueryRequest\`
- [ ] Add \`POST /query\` with \`QueryRequest\` body
- [ ] Return same format as \`GET /query\`
- [ ] Document both endpoints in README

## ✅ Acceptance criteria
- \`POST /query\` with \`{\"q\": \"...\", \"k\": 5}\` returns results
- Pydantic validates input
- Both endpoints documented

## ⚡ Priority
P3" \
  "enhancement,api"

# ---------------------------------------------------------------------------
# EPIC 5 – Configuration & Environment Management
# ---------------------------------------------------------------------------
gh_create_issue \
  "[E5-1] Migrate config to Pydantic BaseSettings" \
  "## 🎯 Goal
Replace the simple \`Settings\` class with Pydantic \`BaseSettings\` for automatic type validation and .env loading.

## 💡 Why it matters
Pydantic BaseSettings is the industry standard for configuration management in FastAPI applications. Misconfiguration fails at startup, not during runtime.

## 📋 Tasks
- [ ] Add \`pydantic-settings\` to dependencies
- [ ] Migrate \`app/core/config.py\` to \`BaseSettings\`
- [ ] Add types and validation for all fields
- [ ] Add \`@validator\` for \`APP_ENV\` (allow only: development, staging, production)
- [ ] Test that the app fails with invalid configuration

## ✅ Acceptance criteria
- Invalid env value gives \`ValidationError\` with clear message at startup
- Types are correct (int for port, etc.)
- \`pydantic-settings\` is in dependencies

## ⚡ Priority
P1" \
  "enhancement,config,python"

gh_create_issue \
  "[E5-2] Document all environment variables in .env.example" \
  "## 🎯 Goal
Update \`.env.example\` with all environment variables, default values, and descriptive comments.

## 💡 Why it matters
\`.env.example\` is the contract between developer and operations environment. A well-commented \`.env.example\` is critical for DevOps and onboarding.

## 📋 Tasks
- [ ] List all existing variables with comments
- [ ] Add new variables (CHUNK_SIZE, EMBEDDING_MODEL, etc.)
- [ ] Distinguish between required and optional variables
- [ ] Document valid values for enum types (APP_ENV)
- [ ] Link to \`.env.example\` from README

## ✅ Acceptance criteria
- All variables used in code exist in \`.env.example\`
- Comments explain what the variable does and valid values
- Distinction between required/optional is clear

## ⚡ Priority
P1" \
  "documentation,config"

gh_create_issue \
  "[E5-3] Add startup configuration validation" \
  "## 🎯 Goal
Validate critical configurations on startup and give a clear error message if something is missing.

## 💡 Why it matters
Fail-fast is a DevOps principle. An app that fails clearly at startup is far easier to operate than one that fails silently during runtime.

## 📋 Tasks
- [ ] Add startup event in \`main.py\` with config checks
- [ ] Check that \`DOCUMENTS_PATH\` exists (create if it doesn't)
- [ ] Check that \`INDEX_PATH\` is writable
- [ ] Log all configurations at startup (mask secrets)
- [ ] Test that app starts correctly and errors fail clearly

## ✅ Acceptance criteria
- Missing \`DOCUMENTS_PATH\` is logged as warning but does not stop app
- Configurations are logged at startup
- No secrets logged in plain text

## ⚡ Priority
P2" \
  "enhancement,config,operational"

gh_create_issue \
  "[E5-4] Support production mode with stricter settings" \
  "## 🎯 Goal
Add \`APP_ENV=production\` mode that activates stricter settings: no reload, JSON logging, higher log threshold.

## 💡 Why it matters
Distinguishing between dev and prod is fundamental in any application operations role. Shows that you think about operations from day one.

## 📋 Tasks
- [ ] Use \`APP_ENV\` to set log level in \`main.py\`
- [ ] Disable FastAPI debug mode in prod
- [ ] Enable JSON logging in prod (see Epic 6)
- [ ] Document the difference in README

## ✅ Acceptance criteria
- \`APP_ENV=production\` gives JSON logging and INFO level
- \`APP_ENV=development\` gives readable text logging and DEBUG level
- Documented in README

## ⚡ Priority
P2" \
  "enhancement,config,operational"

# ---------------------------------------------------------------------------
# EPIC 6 – Logging & Error Handling
# ---------------------------------------------------------------------------
gh_create_issue \
  "[E6-1] Implement structured JSON logging" \
  "## 🎯 Goal
Configure logging to output JSON-formatted logs in production so that log aggregators (Loki, ELK) can parse them.

## 💡 Why it matters
Structured logging is standard in modern DevOps. It is the first thing you set up in an operations environment to be able to search and filter logs effectively.

## 📋 Tasks
- [ ] Add \`python-json-logger\` to dependencies
- [ ] Create \`app/core/logging_config.py\` with logging setup
- [ ] Use JSON formatter in prod, text in dev (based on APP_ENV)
- [ ] Include \`timestamp\`, \`level\`, \`logger\`, \`message\`, \`env\` in all log messages
- [ ] Update \`main.py\` to use the new logging configuration

## ✅ Acceptance criteria
- In production, one JSON line is produced per log event
- In development, readable text logs are produced
- All existing log calls work without modification

## ⚡ Priority
P1" \
  "enhancement,logging,operational"

gh_create_issue \
  "[E6-2] Add request/response logging middleware" \
  "## 🎯 Goal
Add FastAPI middleware that logs all incoming requests and outgoing responses with method, path, status code, and duration.

## 💡 Why it matters
Request logging is critical for operations and debugging. Without it, it is difficult to debug issues in production.

## 📋 Tasks
- [ ] Create \`app/api/middleware.py\`
- [ ] Implement \`LoggingMiddleware\` with \`starlette.middleware\`
- [ ] Log: \`method\`, \`path\`, \`status_code\`, \`duration_ms\`
- [ ] Log at INFO level, errors (5xx) at ERROR level
- [ ] Test that all endpoints are logged

## ✅ Acceptance criteria
- All HTTP calls are logged with status code and duration
- 5xx errors are logged at ERROR level
- Middleware is registered in \`main.py\`

## ⚡ Priority
P1" \
  "enhancement,logging,api"

gh_create_issue \
  "[E6-3] Add global exception handler" \
  "## 🎯 Goal
Add a global exception handler that catches unexpected errors and returns consistent JSON error responses instead of stack traces.

## 💡 Why it matters
Stack traces in API responses are a security and operations problem. Consistent error responses make it easier for clients and operations tools to handle errors.

## 📋 Tasks
- [ ] Add \`@app.exception_handler(Exception)\` in \`main.py\`
- [ ] Return \`{\"error\": \"Internal server error\", \"detail\": null}\` in prod
- [ ] Return details in dev (\`APP_ENV=development\`)
- [ ] Log all unhandled exceptions with stack trace
- [ ] Test with an endpoint that throws an exception

## ✅ Acceptance criteria
- Unexpected errors return 500 with JSON response
- Stack trace is logged but not exposed in prod
- Test demonstrates the behavior

## ⚡ Priority
P2" \
  "enhancement,error-handling,api,security"

gh_create_issue \
  "[E6-4] Add correlation ID to requests" \
  "## 🎯 Goal
Generate a unique \`X-Request-ID\` header for each call and include it in all log messages and responses.

## 💡 Why it matters
Correlation IDs are fundamental for distributed tracing and debugging. Shows understanding of observability in production systems.

## 📋 Tasks
- [ ] Generate UUID per request in middleware
- [ ] Add request-ID to log messages (via context var)
- [ ] Return \`X-Request-ID\` in all responses
- [ ] Accept existing \`X-Request-ID\` from client (pass-through)

## ✅ Acceptance criteria
- All log lines for a call have the same request-ID
- \`X-Request-ID\` header is returned in all responses
- Client's ID is used if sent in the request

## ⚡ Priority
P3" \
  "enhancement,logging,observability"

gh_create_issue \
  "[E6-5] Configure log rotation" \
  "## 🎯 Goal
Configure logging to write to file with automatic rotation so disk does not fill up.

## 💡 Why it matters
Log rotation is standard Linux/operations practice. Missing rotation is a common cause of full disk in production.

## 📋 Tasks
- [ ] Add \`RotatingFileHandler\` to logging configuration
- [ ] Save logs in \`logs/\` folder (already in \`.gitignore\`)
- [ ] Configure max file size and number of backup files via env
- [ ] Document log location in README
- [ ] Test that rotation happens correctly

## ✅ Acceptance criteria
- Logs are written to \`logs/app.log\`
- File rotates automatically when max size is reached
- Number of backup files is configurable

## ⚡ Priority
P3" \
  "enhancement,logging,operational"

# ---------------------------------------------------------------------------
# EPIC 7 – Healthchecks & Observability
# ---------------------------------------------------------------------------
gh_create_issue \
  "[E7-1] Enhance /health endpoint with system-level checks" \
  "## 🎯 Goal
Extend the \`/health\` endpoint to report system status including disk space, index state, and embedding model.

## 💡 Why it matters
A simple \`{\"status\": \"ok\"}\` is not enough for a production system. Rich health information is crucial for monitoring and auto-healing.

## 📋 Tasks
- [ ] Check that \`DOCUMENTS_PATH\` is accessible
- [ ] Report whether index is loaded and number of vectors
- [ ] Report available disk space (via \`shutil.disk_usage\`)
- [ ] Report embedding model status (loaded/not loaded)
- [ ] Return HTTP 200 if all ok, 503 if critical error

## ✅ Acceptance criteria
- \`/health\` returns extended JSON with all checks
- 503 returned if disk space < 100MB
- Response is < 200ms

## ⚡ Priority
P1" \
  "enhancement,healthcheck,observability"

gh_create_issue \
  "[E7-2] Add /ready readiness probe endpoint" \
  "## 🎯 Goal
Add a \`/ready\` endpoint that returns 200 only when the app is fully initialized and ready to serve requests.

## 💡 Why it matters
The readiness/liveness distinction is fundamental in Kubernetes and container operations. Shows concrete knowledge of container orchestration.

## 📋 Tasks
- [ ] Add \`/ready\` endpoint
- [ ] Check that embedding model is loaded
- [ ] Return 503 during startup, 200 when ready
- [ ] Document the difference between \`/health\` and \`/ready\` in README

## ✅ Acceptance criteria
- \`/ready\` returns 503 if model is not loaded
- \`/ready\` returns 200 when fully initialized
- Endpoint is documented

## ⚡ Priority
P2" \
  "enhancement,healthcheck,kubernetes"

gh_create_issue \
  "[E7-3] Add disk usage and uptime to health response" \
  "## 🎯 Goal
Add operational metadata to the health response: uptime, disk usage, process ID.

## 💡 Why it matters
Shows understanding of what operations teams need from a health check. Uptime and disk usage are standard info in production environments.

## 📋 Tasks
- [ ] Add \`uptime_seconds\` (time since startup)
- [ ] Add \`disk_free_gb\` and \`disk_used_percent\`
- [ ] Add \`pid\` (process ID)
- [ ] Add \`version\` from \`pyproject.toml\`

## ✅ Acceptance criteria
- All fields are present in the health response
- Values are correct and update per call

## ⚡ Priority
P2" \
  "enhancement,healthcheck,observability"

gh_create_issue \
  "[E7-4] Add basic /metrics endpoint" \
  "## 🎯 Goal
Add a simple \`/metrics\` endpoint with application statistics: number of requests, documents, chunks.

## 💡 Why it matters
Metrics are the first step toward Prometheus integration. Shows that you think about operational visibility.

## 📋 Tasks
- [ ] Count requests since startup (per endpoint)
- [ ] Return \`{total_requests, documents_indexed, chunks_indexed, queries_served}\`
- [ ] Use in-memory counters (not Prometheus yet)
- [ ] Document in README

## ✅ Acceptance criteria
- \`/metrics\` returns correct statistics
- Counters increase with use
- Documented in README

## ⚡ Priority
P3" \
  "enhancement,observability,metrics"

# ---------------------------------------------------------------------------
# EPIC 8 – Docker & Containerization
# ---------------------------------------------------------------------------
gh_create_issue \
  "[E8-1] Create production-ready Dockerfile with multi-stage build" \
  "## 🎯 Goal
Write a \`Dockerfile\` with a multi-stage build that produces a minimal, secure production image.

## 💡 Why it matters
Docker is the core of modern application operations. A proper Dockerfile with multi-stage build demonstrates concrete container competence.

## 📋 Tasks
- [ ] Create \`Dockerfile\` with two stages: \`builder\` and \`runtime\`
- [ ] Use \`python:3.11-slim\` as base image
- [ ] Install dependencies in builder, copy only necessary files to runtime
- [ ] Run as non-root user (\`appuser\`)
- [ ] Set \`WORKDIR /app\`
- [ ] Expose correct port via \`EXPOSE\`
- [ ] Add \`HEALTHCHECK\` instruction pointing to \`/health\`

## ✅ Acceptance criteria
- \`docker build -t eksamen-rag .\` builds without errors
- Container runs as non-root
- \`docker run\` starts the app
- Image size is documented

## ⚡ Priority
P1 – Do early" \
  "enhancement,docker,infra"

gh_create_issue \
  "[E8-2] Create .dockerignore" \
  "## 🎯 Goal
Add \`.dockerignore\` to keep the Docker build context small and avoid copying unnecessary files into the image.

## 💡 Why it matters
\`.dockerignore\` is a small but important detail that shows you understand the Docker build process and think about performance.

## 📋 Tasks
- [ ] Create \`.dockerignore\`
- [ ] Exclude: \`.git\`, \`.venv\`, \`__pycache__\`, \`*.pyc\`, \`logs/\`, \`indexes/\`, \`.env\`, \`*.md\`
- [ ] Test that build context is small with \`docker build --progress=plain\`

## ✅ Acceptance criteria
- \`.dockerignore\` exists and excludes the correct files
- Build context is < 1MB

## ⚡ Priority
P1" \
  "enhancement,docker,repo-hygiene"

gh_create_issue \
  "[E8-3] Create docker-compose.yml for local development" \
  "## 🎯 Goal
Write a \`docker-compose.yml\` that makes it easy to run the entire application locally with one command.

## 💡 Why it matters
\`docker-compose\` is standard in DevOps environments for local development. Shows practical container orchestration experience.

## 📋 Tasks
- [ ] Create \`docker-compose.yml\`
- [ ] Define \`app\` service with build and port mapping
- [ ] Read environment variables from \`.env\` file
- [ ] Add \`restart: unless-stopped\`
- [ ] Document \`docker-compose up\` in README
- [ ] Test that \`docker-compose up\` starts the app

## ✅ Acceptance criteria
- \`docker-compose up\` starts the app on port 8000
- \`docker-compose down\` stops everything
- README describes the commands

## ⚡ Priority
P1" \
  "enhancement,docker,infra"

gh_create_issue \
  "[E8-4] Configure volume mounts for documents and indexes" \
  "## 🎯 Goal
Configure Docker volume mounts so that \`documents/\` and \`indexes/\` are persistent and can be managed outside the container.

## 💡 Why it matters
Volume mounts are critical for stateful containers. Demonstrates understanding of persistent storage in Docker – a core topic in operations roles.

## 📋 Tasks
- [ ] Add named volumes or bind-mounts for \`documents\` and \`indexes\` in \`docker-compose.yml\`
- [ ] Document how to add documents without rebuilding the image
- [ ] Add comments in \`docker-compose.yml\`

## ✅ Acceptance criteria
- Documents can be added without container rebuild
- Indexes survive container restart
- Documented in README

## ⚡ Priority
P2" \
  "enhancement,docker,infra,storage"

gh_create_issue \
  "[E8-5] Add complete Docker environment variable documentation" \
  "## 🎯 Goal
Document all supported environment variables for Docker runs in README and docker-compose.

## 💡 Why it matters
Clear configuration documentation is a prerequisite for good operations. Reduces onboarding time and errors.

## 📋 Tasks
- [ ] Document all env variables used by the Docker image
- [ ] Add \`environment\` section with comments in \`docker-compose.yml\`
- [ ] Create a table in README: Variable | Default | Description
- [ ] Test that app starts correctly with and without \`.env\` file

## ✅ Acceptance criteria
- README has a complete env variable table
- \`docker-compose.yml\` has \`environment\` section with comments
- App works with default values alone

## ⚡ Priority
P2" \
  "documentation,docker,config"

# ---------------------------------------------------------------------------
# EPIC 9 – Shell Scripts & Automation
# ---------------------------------------------------------------------------
gh_create_issue \
  "[E9-1] Create start.sh and stop.sh scripts" \
  "## 🎯 Goal
Create \`scripts/start.sh\` and \`scripts/stop.sh\` for starting and stopping the application (both local and Docker mode).

## 💡 Why it matters
Shell scripts are a daily tool in Linux/DevOps work. Having clean, documented scripts demonstrates practical Linux competence.

## 📋 Tasks
- [ ] Create \`scripts/\` directory
- [ ] Write \`start.sh\` that starts the app (choose between local and Docker based on \`--docker\` flag)
- [ ] Write \`stop.sh\` that stops containers or the process
- [ ] Add \`set -euo pipefail\` at the top of both scripts
- [ ] Add usage documentation in script headers
- [ ] Make scripts executable (\`chmod +x\`)

## ✅ Acceptance criteria
- \`./scripts/start.sh\` starts the app locally
- \`./scripts/start.sh --docker\` uses Docker
- \`./scripts/stop.sh\` stops gracefully
- Scripts have \`set -euo pipefail\` and usage help text

## ⚡ Priority
P1" \
  "enhancement,shell,automation,linux"

gh_create_issue \
  "[E9-2] Create setup.sh for development environment bootstrap" \
  "## 🎯 Goal
Write \`scripts/setup.sh\` that sets up the entire development environment from scratch: virtualenv, dependencies, directories, \`.env\` file.

## 💡 Why it matters
A bootstrap script reduces onboarding time from hours to minutes. Shows that you think about reproducibility and DevOps culture.

## 📋 Tasks
- [ ] Check Python version (require 3.10+)
- [ ] Create \`.venv\` if it does not exist
- [ ] Install dependencies
- [ ] Copy \`.env.example\` to \`.env\` if \`.env\` is missing
- [ ] Create \`documents/\` and \`indexes/\` directories
- [ ] Print guidance at the end (what to do next)

## ✅ Acceptance criteria
- \`./scripts/setup.sh\` from a fresh clone sets up everything without manual intervention
- Script fails with clear error message if Python version is too old
- Idempotent: safe to run multiple times

## ⚡ Priority
P1" \
  "enhancement,shell,automation,linux"

gh_create_issue \
  "[E9-3] Create ingest.sh script" \
  "## 🎯 Goal
Write \`scripts/ingest.sh\` that triggers ingestion via API call and shows progress in the terminal.

## 💡 Why it matters
Operational scripts for common tasks are standard practice. Shows practical API usage from the shell.

## 📋 Tasks
- [ ] Send \`POST /ingest\` via \`curl\`
- [ ] Show response statistics (number of files, chunks)
- [ ] Handle errors (e.g., app is not running)
- [ ] Add \`--host\` and \`--port\` arguments

## ✅ Acceptance criteria
- \`./scripts/ingest.sh\` triggers ingestion and shows statistics
- Errors are handled with a clear error message
- \`--host\` and \`--port\` are supported

## ⚡ Priority
P2" \
  "enhancement,shell,automation"

gh_create_issue \
  "[E9-4] Create healthcheck.sh script" \
  "## 🎯 Goal
Write \`scripts/healthcheck.sh\` that checks the application health state and returns exit code 0 (healthy) or 1 (unhealthy).

## 💡 Why it matters
Healthcheck scripts are used in Docker and systemd to decide whether a service should be restarted. Shows understanding of automatic service monitoring.

## 📋 Tasks
- [ ] Send \`GET /health\` via curl
- [ ] Parse JSON response and check \`status\` field
- [ ] Return exit code 0 if status=ok, 1 otherwise
- [ ] Add timeout parameter
- [ ] Document usage in README

## ✅ Acceptance criteria
- \`./scripts/healthcheck.sh\` returns exit code 0 if app is healthy
- Exit code 1 if app is down or unhealthy
- Works as HEALTHCHECK command in Dockerfile

## ⚡ Priority
P2" \
  "enhancement,shell,healthcheck,linux"

gh_create_issue \
  "[E9-5] Create backup.sh for index persistence" \
  "## 🎯 Goal
Write \`scripts/backup.sh\` that takes a backup of the FAISS index and documents to a timestamped tarball.

## 💡 Why it matters
Backup routines are fundamental operations practice. Shows that you think about data integrity and recovery.

## 📋 Tasks
- [ ] Create backup of \`indexes/\` with date/time in filename
- [ ] Compress with \`tar -czf\`
- [ ] Store in \`backups/\` directory (add to \`.gitignore\`)
- [ ] Clean up backups older than N days (configurable)
- [ ] Log the backup operation

## ✅ Acceptance criteria
- \`./scripts/backup.sh\` creates a timestamped backup
- Old backups are automatically cleaned up
- \`backups/\` is in \`.gitignore\`

## ⚡ Priority
P3" \
  "enhancement,shell,automation,linux"

# ---------------------------------------------------------------------------
# EPIC 10 – CI Pipeline
# ---------------------------------------------------------------------------
gh_create_issue \
  "[E10-1] Set up GitHub Actions CI workflow" \
  "## 🎯 Goal
Create a simple GitHub Actions workflow that runs on all pull requests and pushes to main.

## 💡 Why it matters
CI is hygiene minimum in any serious project. GitHub Actions is the industry standard and directly relevant for DevOps positions.

## 📋 Tasks
- [ ] Create \`.github/workflows/ci.yml\`
- [ ] Trigger on \`push\` to main and \`pull_request\`
- [ ] Set up Python and install dependencies
- [ ] Run \`ruff check .\` (linting)
- [ ] Run \`pytest\` (testing)
- [ ] Add status badge to README

## ✅ Acceptance criteria
- CI runs automatically on PR and push
- Failing linting or tests blocks merge
- Status badge shown in README

## ⚡ Priority
P1" \
  "ci,automation,repo-hygiene"

gh_create_issue \
  "[E10-2] Add linting step with ruff in CI" \
  "## 🎯 Goal
Configure and integrate \`ruff\` as linter and formatter in the CI pipeline.

## 💡 Why it matters
Automated linting prevents code style discussions in code review and keeps the codebase consistent.

## 📋 Tasks
- [ ] Configure ruff in \`pyproject.toml\`
- [ ] Add ruff step to CI workflow
- [ ] Fix all existing linting errors
- [ ] Document local run in CONTRIBUTING.md

## ✅ Acceptance criteria
- CI fails if ruff reports errors
- \`ruff check .\` passes locally
- Documented in CONTRIBUTING.md

## ⚡ Priority
P2" \
  "ci,code-quality,python"

gh_create_issue \
  "[E10-3] Add pytest unit tests and CI integration" \
  "## 🎯 Goal
Create a \`tests/\` directory with unit tests for core logic and integrate with CI.

## 💡 Why it matters
Testing is fundamental to software quality. Having tests that run automatically demonstrates DevOps maturity.

## 📋 Tasks
- [ ] Create \`tests/\` directory with \`__init__.py\` and \`conftest.py\`
- [ ] Write tests for \`chunk_text()\`, \`load_documents()\`, config, \`/health\`, \`/query\`
- [ ] Use \`httpx\` and FastAPI \`TestClient\`
- [ ] Add coverage reporting with \`pytest-cov\`
- [ ] Integrate into CI

## ✅ Acceptance criteria
- \`pytest\` passes from repo root
- Coverage is > 60%
- CI fails on test failure

## ⚡ Priority
P2" \
  "testing,ci,python"

gh_create_issue \
  "[E10-4] Add Docker build verification in CI" \
  "## 🎯 Goal
Add a CI step that builds the Docker image to confirm the Dockerfile is always in a functional state.

## 💡 Why it matters
A broken Dockerfile is not detected without building it. CI verification ensures the image can always be built.

## 📋 Tasks
- [ ] Add \`docker build\` step to CI
- [ ] Add simple smoke test: start container, run healthcheck
- [ ] Document the Docker step in README

## ✅ Acceptance criteria
- CI fails if Docker build fails
- Container smoke test (healthcheck) passes in CI

## ⚡ Priority
P2" \
  "ci,docker,automation"

gh_create_issue \
  "[E10-5] Add dependency security scanning with pip-audit and Dependabot" \
  "## 🎯 Goal
Add automated security scanning of Python dependencies with \`pip-audit\` and GitHub Dependabot.

## 💡 Why it matters
Security scanning of dependencies is an industry requirement and DevSecOps practice. Shows awareness of supply chain security.

## 📋 Tasks
- [ ] Enable Dependabot in \`.github/dependabot.yml\`
- [ ] Add \`pip-audit\` step to CI
- [ ] Configure Dependabot for automatic PRs on CVE
- [ ] Document security routines in CONTRIBUTING.md

## ✅ Acceptance criteria
- Dependabot creates PR on vulnerable dependencies
- \`pip-audit\` runs in CI
- CONTRIBUTING.md documents security reporting

## ⚡ Priority
P3" \
  "ci,security,automation"

# ---------------------------------------------------------------------------
# EPIC 11 – Reverse Proxy & Networking
# ---------------------------------------------------------------------------
gh_create_issue \
  "[E11-1] Add nginx configuration for API reverse proxy" \
  "## 🎯 Goal
Create an nginx configuration that acts as a reverse proxy in front of the FastAPI app.

## 💡 Why it matters
Reverse proxy is standard in production setups for handling TLS, rate limiting, and static content. Nginx is the most common choice.

## 📋 Tasks
- [ ] Create \`nginx/nginx.conf\`
- [ ] Configure proxy_pass to the FastAPI service
- [ ] Set sensible timeouts and headers
- [ ] Forward \`X-Forwarded-For\` and \`X-Real-IP\`

## ✅ Acceptance criteria
- nginx proxies calls to FastAPI correctly
- Headers are forwarded

## ⚡ Priority
P2" \
  "enhancement,nginx,infra,networking"

gh_create_issue \
  "[E11-2] Integrate nginx service in docker-compose" \
  "## 🎯 Goal
Add nginx as a service in \`docker-compose.yml\` in front of the FastAPI app.

## 💡 Why it matters
A docker-compose setup with nginx and app is a classic production setup that is directly transferable to Kubernetes.

## 📋 Tasks
- [ ] Add \`nginx\` service to \`docker-compose.yml\`
- [ ] Map port 80 (nginx) instead of 8000 (app directly)
- [ ] Connect nginx to app via internal Docker network
- [ ] Update README with new port and setup

## ✅ Acceptance criteria
- \`docker-compose up\` starts both nginx and app
- API is accessible on port 80 via nginx
- App is not directly accessible from outside

## ⚡ Priority
P2" \
  "enhancement,nginx,docker,networking"

gh_create_issue \
  "[E11-3] Configure rate limiting in nginx" \
  "## 🎯 Goal
Configure rate limiting in nginx to restrict the number of requests per IP per second.

## 💡 Why it matters
Rate limiting protects the service from abuse and overload – an important operational consideration.

## 📋 Tasks
- [ ] Add \`limit_req_zone\` and \`limit_req\` to nginx.conf
- [ ] Set limit for \`/query\` endpoint (e.g. 10 req/s)
- [ ] Return 429 for too many requests
- [ ] Test with \`ab\` or \`curl\` loop

## ✅ Acceptance criteria
- Over-limit requests return 429
- Limit is configurable in nginx.conf

## ⚡ Priority
P3" \
  "enhancement,nginx,security,networking"

gh_create_issue \
  "[E11-4] Document SSL/TLS setup with self-signed certificate" \
  "## 🎯 Goal
Document and write a script for setting up SSL with a self-signed certificate for local development.

## 💡 Why it matters
Even though prod TLS is handled by Certbot/Let's Encrypt, knowledge of certificates and HTTPS setup shows fundamental security understanding.

## 📋 Tasks
- [ ] Write \`scripts/generate-certs.sh\` with \`openssl\` commands
- [ ] Update nginx.conf with SSL configuration
- [ ] Add \`certs/\` to \`.gitignore\`
- [ ] Document in README

## ✅ Acceptance criteria
- \`./scripts/generate-certs.sh\` generates a self-signed cert
- HTTPS works locally on port 443
- Certificate files are in \`.gitignore\`

## ⚡ Priority
P3" \
  "documentation,security,nginx,linux"

# ---------------------------------------------------------------------------
# EPIC 12 – Kubernetes/OpenShift-Inspired Structure
# ---------------------------------------------------------------------------
gh_create_issue \
  "[E12-1] Create k8s/ directory with Deployment manifest" \
  "## 🎯 Goal
Create a \`k8s/\` directory with a Kubernetes Deployment manifest for the application.

## 💡 Why it matters
Even if we don't deploy to Kubernetes yet, the manifest structure demonstrates understanding of container orchestration and makes future migration easy.

## 📋 Tasks
- [ ] Create \`k8s/\` directory
- [ ] Write \`k8s/deployment.yaml\` with correct resource limits
- [ ] Use \`imagePullPolicy: IfNotPresent\` for local development
- [ ] Set \`replicas: 1\`
- [ ] Add liveness and readiness probes

## ✅ Acceptance criteria
- \`kubectl apply -f k8s/deployment.yaml\` works (if kubectl is installed)
- Liveness and readiness probes point to \`/health\` and \`/ready\`

## ⚡ Priority
P3" \
  "enhancement,kubernetes,infra"

gh_create_issue \
  "[E12-2] Add ConfigMap and Secret templates" \
  "## 🎯 Goal
Create Kubernetes ConfigMap and Secret templates for application configuration.

## 💡 Why it matters
ConfigMaps and Secrets are the Kubernetes way of handling configuration – directly analogous to Docker env vars and volumes.

## 📋 Tasks
- [ ] Create \`k8s/configmap.yaml\` with non-secret configurations
- [ ] Create \`k8s/secret.yaml.example\` (never real values)
- [ ] Update Deployment to use ConfigMap
- [ ] Document in README

## ✅ Acceptance criteria
- ConfigMap and Secret templates exist
- Deployment uses ConfigMap
- No real secrets in \`secret.yaml\`

## ⚡ Priority
P3" \
  "enhancement,kubernetes,config"

gh_create_issue \
  "[E12-3] Add Service and Ingress manifests" \
  "## 🎯 Goal
Write Kubernetes Service and Ingress manifests to expose the app externally.

## 💡 Why it matters
Service and Ingress are the Kubernetes alternative to nginx reverse proxy in docker-compose. Shows breadth of infrastructure knowledge.

## 📋 Tasks
- [ ] Create \`k8s/service.yaml\` (ClusterIP)
- [ ] Create \`k8s/ingress.yaml\` with nginx ingress class
- [ ] Document in README

## ✅ Acceptance criteria
- Service and Ingress manifests exist and are syntactically correct
- Documented in README

## ⚡ Priority
P3" \
  "enhancement,kubernetes,networking"

gh_create_issue \
  "[E12-4] Add PersistentVolumeClaim for document storage" \
  "## 🎯 Goal
Add a PVC manifest for persistent storage of documents and indexes in Kubernetes.

## 💡 Why it matters
PVCs are the Kubernetes equivalent of Docker bind-mounts. Shows understanding of persistent storage in orchestrated environments.

## 📋 Tasks
- [ ] Create \`k8s/pvc.yaml\` for documents and indexes
- [ ] Update Deployment to mount the PVC
- [ ] Document in README

## ✅ Acceptance criteria
- PVC manifest exists
- Deployment references PVC correctly
- Documented

## ⚡ Priority
P3" \
  "enhancement,kubernetes,storage"

# ---------------------------------------------------------------------------
# Done
# ---------------------------------------------------------------------------
log "All issues created successfully!"
log "View your issues at: https://github.com/${REPO}/issues"
