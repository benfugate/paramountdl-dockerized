# paramount-dl dockerized

---

Instructions to run without docker are at the bottom.

Docker container that calls bash scripts to download from Paramount+ using youtube-dl,
including Grandfather-Paradox's script that fixes the picture/audio lag/desync
issues from Paramount+ youtube-dl downloads.

English subtitles are also downloaded and muxed into an MKV with the video/audio.

This container will download seasons concurrently, but episodes within the seasons will be sequential.

Dependencies: docker

---

### Usage:

#### Using my docker image

1. `docker run -v $PWD/downloads:/usr/src/app/downloads benfugate/paramountdl <SHOW_URL>`

#### Building your own

1. `docker build -t paramountdl .`

2. `docker run -v $PWD/downloads:/usr/src/app/downloads paramountdl <SHOW_URL>`

Replace `<SHOW_URL>` with your desired show, ex. `https://www.paramountplus.com/shows/survivor/`. The trailing slash is required, and anything extra will be trimmed off by the script.

Mounting the 'download' folder is required so that episodes will appear on your local filesystem, outside of docker.

---

### Credits:

> Wrote the script that downloads, and verifies downloads
>
> https://github.com/Grandfather-Paradox/paramount-dl/

> Wrote a script to batch download paramount shows. I stripped some of the script,
> because I only needed the links file it generated.
> 
> https://github.com/ohmybahgosh/YT-DLP-SCRIPTS/blob/main/PARAMOUNT-YTDLP/PARAMOUNT-V2-YTDLP

---

### Running without Docker

This can be run without docker, pretty easily. All the dependencies have to be installed though.

> #### Dependencies:
> 
> wget, curl, jq, mkvtoolnix, mediainfo, ffmpeg, xidel, youtube-dl, pycryptodome

#### Usage:
1. `./download_show.sh <SHOW_URL>`

Replace `<SHOW_URL>` with your desired show, ex. `https://www.paramountplus.com/shows/survivor/`. The trailing slash is required, and anything extra will be trimmed off by the script.

---

#### This repo was created to solve the following issues more efficiently than the current avaiable solutions

- https://github.com/ytdl-org/youtube-dl/issues/27972
- https://github.com/yt-dlp/yt-dlp/issues/898