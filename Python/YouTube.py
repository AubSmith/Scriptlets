# HOW TO: Download YouTube Videos Programmatically with Python & pytube
# $ pip install pytube
# $ python3 download.py

from pytube import Playlist
from pytube import YouTube as YT
import threading as th
import time

DOWNLOAD_DIR = 'D:\\'

plist=input('Enter the playlist: ')

videos=list(Playlist(plist))
i=videos[0]
video=YT(i, use_oauth=True, allow_oauth_cache=True)
strm=video.streams.filter(res="720p")
print(strm)
treams.filter(file_extension='mp4', res="720p").first().download()