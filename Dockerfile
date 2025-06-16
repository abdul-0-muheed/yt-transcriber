FROM python:3.10-slim  # ✅ Use Python 3.10, not 3.13

# Install OS-level dependencies
RUN apt-get update && apt-get install -y \
    ffmpeg \
    git \
    curl \
    build-essential \
    && apt-get clean

# Install Python dependencies
RUN pip install --upgrade pip
RUN pip install fastapi uvicorn yt-dlp openai-whisper pydub ffmpeg-python

# Set working directory
WORKDIR /app

# Copy app files
COPY app /app

# Run the FastAPI server
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
