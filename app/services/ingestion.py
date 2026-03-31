import os
import app.core.config as config


def load_documents():
    documents = []
    documents_path = config.settings.DOCUMENTS_PATH

    if not os.path.isdir(documents_path):
        return documents

    for filename in os.listdir(documents_path):
        filepath = os.path.join(documents_path, filename)

        if not os.path.isfile(filepath):
            continue

        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        documents.append({
            "filename" : filename,
            "content" : content
        })

    return documents


def chunk_text(text: str, chunk_size: int = 200) -> list:
    chunks = []

    for i in range(0,len(text),chunk_size):
        chunk = text[i:i+chunk_size]
        chunks.append(chunk)

    return chunks


def ingest_documents():
    raw_docs = load_documents()
    processed_chunks = []

    for doc in raw_docs:
        chunks = chunk_text(doc["content"])

        for index, chunk in enumerate(chunks):
            processed_chunks.append(
                {
                    "filename": doc["filename"],
                    "chunk_index": index,
                    "content": chunk,
                }
            )

    return processed_chunks
