#!/usr/bin/env bash

function checkStringClassContains {
	if ! [[ -n $2 ]]; then
		return 1
	fi

	if [[ $(echo $2 | grep -E '['^$1']' | wc -l) -gt 0 ]]; then
		return 1
	fi

	return 0
}
#  @ $1 检测标准
#  @ $2 被检测字符串

function checkStringContainsIi {
	if ! [[ -n $2 ]]; then
		return 1
	fi

	if ! echo $2 | grep -qi $1; then
		return 1
	fi

	return 0
}
#  @ $1 包含对象
#  @ $2 被检测字符串

function checkStringContainsII {
	if ! [[ -n $2 ]]; then
		return 1
	fi

	if ! echo $2 | grep -q $1; then
		return 1
	fi

	return 0
}
#  @ $1 包含对象
#  @ $2 被检测字符串

function checkStringMatchII {
	if ! [[ -n $2 ]]; then
		return 1
	fi

	if ! echo $1 | grep -qw $2; then
		return 1
	fi

	return 0
}
#  @ $1 $2 Args

function checkStringMatchIi {
	if ! [[ -n $2 ]]; then
		return 1
	fi

	if ! echo $1 | grep -qwi $2; then
		return 1
	fi

	return 0
}
#  @ $1 $2 Args

function checkStringNull() {
	if [[ -n $1 ]]; then
		return 1
	fi

	return 0
}
#  @ $1 被检测字符串

function getFileStuff {
	export $2=$(echo $1 | awk -F '.' '{print $NF}')
}
#  @ $1 文件名
#  @ $2 返回变量
