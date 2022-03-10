# paramount-dl dockerized

---

Docker container that calls bash scripts to download from Paramount+ using youtube-dl,
including Grandfather-Paradox's script that fixes the picture/audio lag/desync
issues from Paramount+ youtube-dl downloads.

English subtitles are also downloaded and muxed into an MKV with the video/audio.

This container will download seasons concurrently, but episodes within the seasons will be sequential.

Dependencies: docker

---

Usage:

`docker build -t paramountdl .`

`docker run -v $PWD/downloads:/usr/src/app/downloads paramountdl <SHOW_URL>`


Replace `<SHOW_URL>` with your desired show, ex. `https://www.paramountplus.com/shows/survivor/`

Mounting the 'download' folder is required so that episodes will appear on your local filesystem, outside of docker.

---

Credits:

> Wrote the script that downloads, and verifies downloads
>
> https://github.com/Grandfather-Paradox/paramount-dl/blob/main/LICENSE

> Wrote a script to batch download paramount shows. I stripped some of the script,
> because I only needed the links file it generated.
> 
> https://github.com/ohmybahgosh/YT-DLP-SCRIPTS/blob/main/PARAMOUNT-YTDLP/PARAMOUNT-V2-YTDLP