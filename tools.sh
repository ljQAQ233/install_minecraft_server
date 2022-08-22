#!/usr/bin/env bash

function numFindMax {
	export $2=$(echo $1 | awk -F ' ' '{Max=$1;idx=1;while ( idx <=NF ){if ($idx > Max) Max=$idx;idx++};print Max}')
}

function numFindMin {
	export $2=$(echo $1 | awk -F ' ' '{Min=$1;idx=1;while ( idx <=NF ){if ($idx < Min) Min=$idx;idx++};print Min}')
}
