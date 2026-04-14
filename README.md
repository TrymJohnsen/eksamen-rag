# Eksamen RAG

## How to run

1. Create a virtual environment:

```bash
python3 -m venv .venv
```

2. Activate it:

```bash
source .venv/bin/activate
```

3. Install backend dependencies:

```bash
pip install -r requirements.txt
```

4. Install ML dependencies for embeddings:

```bash
pip install -r requirements-ml.txt
```

5. Create a local `.env` file from the example:

```bash
cp .env.example .env
```

6. Run the server:

```bash
uvicorn app.main:app --reload
```

The app reads host, port, paths, chunk size, and embedding model from environment variables loaded via `.env`.
