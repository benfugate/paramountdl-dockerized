#!/bin/bash

SCRIPT_HOME=$PWD
URL_SLUG=$(echo $1 | sed -E 's/^.*shows\/([^\/]*)\/().*$/\1/')

## Determine How Many Seasons The Series Has By Piping CURL Output in to XIDEL
SEASON_COUNT=$(curl --silent "https://www.paramountplus.com/shows/$URL_SLUG/" | xidel -s --xpath "//option" - | wc -l)
if [ "$SEASON_COUNT" -eq "0" ]; then
  SEASON_COUNT_ALT=$(curl --silent "https://www.paramountplus.com/shows/$URL_SLUG/" | xidel -s --xpath "//p[@class='seasonEpisode']")
  if [ "$SEASON_COUNT_ALT" != "0" ]; then
    SEASON_COUNT=1
  else
    echo "No Seasons Found"
    exit 1
  fi
fi

while read -r SEASON_NUMBER; do
  # Create the folders for the show and season
  mkdir -p downloads/$URL_SLUG/season_$SEASON_NUMBER
  cp paramount-dl.sh downloads/$URL_SLUG/season_$SEASON_NUMBER

  # Now That We Know How Many Seasons We're Working With, Let's Pull The JSON For Each Season
  JSON_DUMP=$(curl "https://www.paramountplus.com/shows/$URL_SLUG/video/xhr/episodes/page/0/size/1000/xs/0/season/$SEASON_NUMBER/" -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'X-Requested-With: XMLHttpRequest' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-origin' -H 'Referer: https://www.paramountplus.com/shows/' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' -H 'TE: trailers')

  # For Each Season We Loop Thru, We'll Extract The Episode URLs in to a TXT File
  echo $JSON_DUMP | jq -r '.result.data[].metaData.videoPageURL' | sed 's#^#https://paramountplus.com#g' >> downloads/$URL_SLUG/season_$SEASON_NUMBER/links.txt
  EPISODES=`echo $JSON_DUMP | jq -r '.result.data[].episode_number'`

  # For each season, begin downloading episodes sequentually
  cd downloads/$URL_SLUG/season_$SEASON_NUMBER/
  /bin/bash paramount-dl.sh $SEASON_NUMBER $EPISODES &
  cd $SCRIPT_HOME
done< <(seq $SEASON_COUNT)

# Keep this script running until all season scripts have finished
while pgrep -fl "paramount-dl.sh" >/dev/null; do sleep 6; done
exit