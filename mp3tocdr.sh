#!/usr/bin/env bash
#
# -----------------------------------------------------------------------------
# mp3tocdr.sh - converts MP3 files to CDR files ready for cdrecord burning
# -----------------------------------------------------------------------------
#
# (c) Copyright 2007 Nicolas Cavigneaux. All Rights Reserved.

if [[ $1 == '-h' ]]; then
	echo 'usage: '
	echo '-h : show this help'
	echo '-r : remove MP3 after processing'
	exit 0
fi

IFS=$(echo -e "\n\r\t")
mkdir cdr/
for nom_mp3 in $(ls *.mp3) ; do
	echo "Processing ${nom_mp3}"
    sox "${nom_mp3}" "cdr/$(basename ${nom_mp3} .mp3).cdr"
	if [[ $1 == '-r' ]]; then
		rm -f "${nom_mp3}"
	fi
done 
