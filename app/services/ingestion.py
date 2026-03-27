import os
import app.core.config as config

def load_documents():
    documents = []

    for filename in os.listdir(config.settings.DOCUMENTS_PATH):
        filepath = os.path.join(config.settings.DOCUMENTS_PATH, filename)

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