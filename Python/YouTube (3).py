# HOW TO: Download YouTube Videos Programmatically with Python & pytube
# $ pip install pytube
# $ python3 download.py

from pytube import YouTube

def on_progress(stream, chunk, bytes_remaining):
    print("Downloading...")

def on_complete(stream, file_path):
    print("Download Complete")

yt = YouTube(
        "https://youtu.be/wlSG3pEiQdc",
        on_progress_callback=on_progress,
        on_complete_callback=on_complete,
        use_oauth=False,
        allow_oauth_cache=True
    )

yt.streams.filter(file_extension='mp4', res="720p").first().download()