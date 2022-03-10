#!/bin/bash

URL_SLUG=$(echo $1 | sed -E 's/^.*shows\/([^\/]*)\/().*$/\1/')

## Let's Set The Output Directory That We'll Work Inside of
OUTPUTDIR=$PWD
cd $OUTPUTDIR

## Determine How Many Seasons The Series Has By Piping CURL Output in to XIDEL
SEASON_COUNT=$(curl --silent "https://www.paramountplus.com/shows/$URL_SLUG/" | xidel -s --xpath "//option" - | wc -l)
if [ "$SEASON_COUNT" -eq "0" ]; then
    SEASON_COUNT_ALT=$(curl --silent "https://www.paramountplus.com/shows/$URL_SLUG/" | xidel -s --xpath "//p[@class='seasonEpisode']")
fi

## Begin Loop..
while read -r SEASON_NUMBER; do
  mkdir -p downloads/season_$SEASON_NUMBER
  cp paramount-dl.sh downloads/season_$SEASON_NUMBER
	# Now That We Know How Many Seasons We're Working With, Let's Pull The JSON For Each Season
	JSON_DUMP=$(curl "https://www.paramountplus.com/shows/$URL_SLUG/video/xhr/episodes/page/0/size/1000/xs/0/season/$SEASON_NUMBER/" -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0' -H 'Accept: application/json, text/javascript, */*; q=0.01' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'X-Requested-With: XMLHttpRequest' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-origin' -H 'Referer: https://www.paramountplus.com/shows/' -H 'Connection: keep-alive' -H 'Cache-Control: max-age=0' -H 'TE: trailers')

	# For Each Season We Loop Thru, We'll Extract The Episode URLs in to a TXT File
	echo $JSON_DUMP | jq -r '.result.data[].metaData.videoPageURL' | sed 's#^#https://paramountplus.com#g' >> downloads/season_$SEASON_NUMBER/links.txt

	cd downloads/season_$SEASON_NUMBER/
	/bin/bash paramount-dl.sh &
	cd ../..
done< <(seq $SEASON_COUNT)

while pgrep -fl "paramount-dl.sh"; do sleep 6; done
exit