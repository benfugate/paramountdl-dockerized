# paramount-dl dockerized

---

This tool is becoming less useful as Paramount continues to add DRM to more of their content.
If you know your desired show is DRM free, then you are good to go!

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

Replace <SHOW_URL> with the url to the show on paramount.

To run with a cookies.txt file (useful if logged into paramount), add "-v <cookies.txt_path>:/usr/src/app/cookies.txt"
to the docker run command, replacing <cookies.txt_path> with the path to your local cookies.txt file.

cookies.txt can be easily obtained using an extension like "Get cookies.txt"
#### Building your own

1. `docker build -t paramountdl .`

2. `docker run -v $PWD/downloads:/usr/src/app/downloads paramountdl <SHOW_URL>`

Replace `<SHOW_URL>` with your desired show, ex. `https://www.paramountplus.com/shows/survivor/`.
**The trailing slash is required**, and anything extra will be trimmed off by the script.

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
cookies are also not supported in this mode.

> #### Dependencies:
> 
> wget, curl, jq, mkvtoolnix, mediainfo, ffmpeg, xidel, yt-dlp, pycryptodome

#### Usage:
1. `./download_show.sh <SHOW_URL>`

Replace `<SHOW_URL>` with your desired show, ex. `https://www.paramountplus.com/shows/survivor/`. The trailing slash is required, and anything extra will be trimmed off by the script.

---

#### This repo was created to solve the following issues more efficiently than the current avaiable solutions

- https://github.com/ytdl-org/youtube-dl/issues/27972
- https://github.com/yt-dlp/yt-dlp/issues/898