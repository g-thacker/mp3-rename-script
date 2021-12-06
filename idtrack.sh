#!/bin/bash

IFS='
'

FILENAME=$1

if ! command -v id3v2 &> /dev/null; then
	echo "$0 requires id3v2 to be installed"
	exit 2
fi

if [ $# -lt 1 ]; then
	echo "$0: Missing argument\nProvide the path to an MP3 file"
	exit 2
elif [ $# -gt 1 ]; then
	echo "$0: Too many arguments\nScript cannot take multiple arguments"
fi

if [ ! -f "$1" ]; then
	echo "$0: File not found"
	exit 2
fi

if [[ $FILENAME != *.mp3 ]]; then
	echo "$0: File must be in MP3 format"
	exit 2
fi

CONFIRMED="n"
while [ "$CONFIRMED" != "y" ]; do
	read -p 'Track title: ' TITLE
	read -p 'Track artist: ' ARTIST
	INTCHECK=0
	while [ $INTCHECK -eq 0 ]; do
		read -p 'Year: ' YEAR
		if [[ $((YEAR)) != $YEAR ]]; then
			echo "Year must be an integer"
		else
			INTCHECK=1
		fi
	done
	read -rep "Is this information correct? (y/n) " CONFIRMED
done

id3v2 -t "$TITLE" -a "$ARTIST" -y "$YEAR" "$1" || echo "Failed to write id3 info"

TMPNAME="$ARTIST.$TITLE.mp3"
NEWNAME=$(echo "$TMPNAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
echo "Renaming file \"$NEWNAME\""

mv $FILENAME $NEWNAME

exit 0
