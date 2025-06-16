from fastapi import FastAPI
from pydantic import BaseModel
from yt_dlp import YoutubeDL
import whisper
import os
from pydub import AudioSegment

app = FastAPI()
model = whisper.load_model("base")

class VideoInput(BaseModel):
    youtube_url: str

@app.post("/transcribe")
async def transcribe(input: VideoInput):
    url = input.youtube_url
    audio_filename = "audio.mp3"
    wav_filename = "audio.wav"

    # Download YouTube audio
    with YoutubeDL({'format': 'bestaudio', 'outtmpl': audio_filename}) as ydl:
        ydl.download([url])

    # Convert to WAV
    audio = AudioSegment.from_file(audio_filename)
    audio.export(wav_filename, format="wav")

    # Transcribe using Whisper
    result = model.transcribe(wav_filename)

    # Clean up
    os.remove(audio_filename)
    os.remove(wav_filename)

    return {"transcript": result["text"]}
