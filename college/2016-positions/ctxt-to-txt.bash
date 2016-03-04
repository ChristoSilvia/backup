#!/usr/bin/env bash

paragraph_begun_last_line=false;

while IFS='' read -r line || [[ -n "$line" ]]; do
	
	if [ $line -eq "\n" ]; then
		$paragraph_begun_last_line=true;
	elif [ ${line:0:1} -eq "\t" ]
		if [ $paragraph_begun_last_line ]; then
			echo "\t${line:1:}";
		else
	fi



	echo "line: $line"
done < "$1"
