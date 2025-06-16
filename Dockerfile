FROM python:3.10-slim

# System packages
RUN apt-get update && apt-get install -y ffmpeg git curl build-essential

# Whisper needs ffmpeg and git
RUN pip install --upgrade pip
RUN pip install fastapi uvicorn yt-dlp openai-whisper pydub ffmpeg-python

# App files
WORKDIR /app
COPY app /app

# Run server
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
