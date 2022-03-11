FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

RUN apt-get update && \
    apt-get install -y jq wget ca-certificates curl \
        mkvtoolnix mediainfo ffmpeg \
        python3 python3-pip python-is-python3 && \
    wget https://github.com/ytdl-org/youtube-dl/releases/latest/download/youtube-dl -O /usr/local/bin/youtube-dl && \
    chmod a+x /usr/local/bin/youtube-dl && \
    wget https://github.com/benibela/xidel/releases/download/Xidel_0.9.8/xidel_0.9.8-1_amd64.deb && \
    dpkg -i xidel_0.9.8-1_amd64.deb && \
    pip3 install pycryptodome

WORKDIR /usr/src/app
RUN mkdir downloads
ADD src/download_show.sh .
ADD src/paramount-dl.sh .

ENTRYPOINT ["./download_show.sh"]