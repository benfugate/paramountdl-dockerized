#!/bin/bash

# Copyright 2022 /u/Grandfather-Paradox

fileDurRegex="([0-9]+):([0-9]+):([0-9]+)\.[0-9]+"
streamHrsMinsSecsRegex="([0-9]+):([0-9]+):([0-9]+)"
streamMinsSecsRegex="([0-9]+):([0-9]+)"
streamSecsRegex="[0-9]+"

convert_to_seconds () {
  dur=$1
  if [[ $dur =~ $fileDurRegex || $dur =~ $streamHrsMinsSecsRegex ]]
  then
    hrs=$(echo "${BASH_REMATCH[1]}" | sed 's/^0*//')
    mins=$(echo "${BASH_REMATCH[2]}" | sed 's/^0*//')
    secs=$(echo "${BASH_REMATCH[3]}" | sed 's/^0*//')
  elif [[ $dur =~ $streamMinsSecsRegex ]]
  then
    hrs=0
    mins=$(echo "${BASH_REMATCH[1]}" | sed 's/^0*//')
    secs=$(echo "${BASH_REMATCH[2]}" | sed 's/^0*//')
  elif [[ $dur =~ $streamSecsRegex ]]
  then
    hrs=0
    mins=0
    secs=$dur
  fi

  if [[ -z $hrs ]]; then hrs=0; fi
  if [[ -z $mins ]]; then mins=0; fi
  if [[ -z $secs ]]; then secs=0; fi

  totalSecs=$(( $hrs*360 + $mins*60 + $secs ))
  echo $totalSecs
}

currentEpisode=1
totalEpisodes=$(wc -l links.txt | sed 's/ links.txt//')
while read link; do
  retryDownload=true
  while [ $retryDownload = true ]
  do
    echo -e "\e[36m[ $currentEpisode / $totalEpisodes ]\e[0m"

    filename=$(yt-dlp -q --no-warnings --get-filename "$link")
    base=$(basename "$filename" .mp4)
    srt="$base.en.srt"
    mkv="$base.mkv"
    if [[ ! -f "$mkv" ]]
    then
      FILE=/usr/src/app/cookies.txt
      if test -f "$FILE"; then
        yt-dlp --cookies /usr/src/app/cookies.txt -q --no-warnings --hls-prefer-native --fragment-retries infinite --retries infinite --sub-lang en --write-sub --convert-subs srt "$link"
      else
        yt-dlp -q --no-warnings --hls-prefer-native --fragment-retries infinite --retries infinite --sub-lang en --write-sub --convert-subs srt "$link"
      fi

      if [[ -f "$srt" ]]
      then
        mkvmerge -o "$mkv" "$filename" "$srt"
        mkvpropedit "$mkv" --edit track:s1 --set language=eng
        rm "$srt"
      else
        mkvmerge -o "$mkv" "$filename"
      fi
      mkvpropedit "$mkv" --edit track:a1 --set language=eng --edit track:v1 --set language=eng

      rm "$filename"

      fileDur=$(mediainfo --Inform="Video;%Duration/String3%" "$mkv")
      streamDur=$(yt-dlp --no-warnings --get-duration "$link")
      totalFileSec=$(convert_to_seconds $fileDur)
      echo "Total file secs: $totalFileSec"
      totalStreamSec=$(convert_to_seconds $streamDur)
      echo "Total stream secs: $totalStreamSec"

      if [[ $totalFileSec -eq $totalStreamSec || $totalFileSec -eq $(( $totalStreamSec-1 )) ]]
      then
        echo -e "\e[32mDownload OK\e[0m"
        retryDownload=false
        currentEpisode=$(( $currentEpisode+1 ))
      else
        echo -e "\e[31mError found, retrying...\e[0m"
        rm "$mkv"
      fi
    else
      echo -e "\e[32mAlready downloaded\e[0m"
      retryDownload=false
      currentEpisode=$(( $currentEpisode+1 ))
    fi
  done
done <links.txt

exit 0