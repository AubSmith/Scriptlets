# HOW TO: Download YouTube Videos Programmatically with Python & pytube
# $ pip install pytube
# $ python3 download.py

from pytube import Playlist
from pytube import YouTube as YT
import threading as th
import time

# plist=input('Enter the playlist: ')
plist='PLAcZNjv5a1Aig8ZoqwysPyGmEhuJEsWVe'

videos=list(Playlist(plist))
i=videos[0]
video=YT(i, use_oauth=True, allow_oauth_cache=True)
strm=video.streams.filter(res="720p")
print(strm)
