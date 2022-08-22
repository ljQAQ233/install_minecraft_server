#!/usr/bin/env bash

source ${SCRIPT_HOME}/checkString.sh
source ${SCRIPT_HOME}/output.sh

function _JarChecker {
	JAR_FILE=$1
	JAR_FILE_NAME=$(busybox basename ${JAR_FILE})
	JAR_FILE_PATH=$(realpath ${JAR_FILE})
	WORKED_HOME=$(pwd)

	cd /tmp
	mkdir -p JarChecker
	cd JarChecker
	cp -ra ${JAR_FILE_PATH} .

	echo -n "Checking the Main Class in the Jar..."
	INFO_FILE=$(busybox unzip -v ${JAR_FILE_NAME} | grep META-INF | grep MF | awk '{print $8}')
	if [[ $? != 0 ]]; then
		return 1
	fi
	busybox unzip ${JAR_FILE_NAME} -o ${INFO_FILE} -qq
	if [[ $? != 0 ]]; then
		return 1
	fi
	MAIN_CLASS_NAME=$(cat ${INFO_FILE} | grep "Main-Class" | awk '{print $2}')
	PrintBlue "${MAIN_CLASS_NAME}"

	echo -n "Checking the Path of the Main Class in the Jar..."
	MAIN_SYMBOL=$(echo ${MAIN_CLASS_NAME} | awk -F '.' '{print $(NF-1)}')
	MAIN_FILE_PATH=$(busybox unzip -v ${JAR_FILE_NAME} | grep Main.class | grep $MAIN_SYMBOL | awk '{print $8}' | awk 'NR==1 {print $1}')
	if [[ $? != 0 ]]; then
		return 1
	fi
	PrintBlue "${MAIN_FILE_PATH}"

	echo -n "Checking the Major Version of the Jar..."
	busybox unzip ${JAR_FILE_NAME} -o ${MAIN_FILE_PATH} -qq
	if [[ $? != 0 ]]; then
		return 1
	fi
	HEX_RAW=$(head -c8 ${MAIN_FILE_PATH} | tail -c2 | busybox hexdump | awk 'NR == 1 {print $2}')
	HEX=$(echo ${HEX_RAW} | tail -c3)$(echo ${HEX_RAW} | head -c2)
	PrintBlue "0x${HEX}"

	export $2=$(echo $((16#${HEX})))

	cd ..
	rm -rf JarChecker
	cd ${WORKED_HOME}
}

function _ClassChecker {
	CLASS_FILE=$1
	HEX_RAW=$(head -c8 ${CLASS_FILE} | tail -c2 | busybox hexdump | awk 'NR == 1 {print $2}')
	HEX=$(echo ${HEX_RAW} | tail -c3)$(echo ${HEX_RAW} | head -c2)
	export $2=$(echo $((16#${HEX})))
}

function checkPkgMajorVersion {
	FILE=$1

	if ! [[ -n $2 ]]; then
		return 1
	fi

	if ! [[ -f ${FILE} ]]; then
		return 1
	fi

	getFileStuff ${FILE} FILE_NAME_STUFF
	if checkStringMatchIi ${FILE_NAME_STUFF} "class"; then
		_ClassChecker ${FILE} $2
		if [[ $? != 0 ]]; then
			return 1
		fi
	elif checkStringMatchIi ${FILE_NAME_STUFF} "jar"; then
		_JarChecker ${FILE} $2
		if [[ $? != 0 ]]; then
			return 1
		fi
	fi
}

function majorToJavaVersion {
	if ! [[ -n $2 ]]; then
		return 1
	fi

	#  所有的选项有微调，不必要处有删改，以适应本脚本实际需求
	if checkStringContainsIi "61" $1; then
		export $2=17
	elif checkStringContainsIi "60" $1; then
		export $2=17
	elif checkStringContainsIi "55" $1; then
		export $2=11
	elif checkStringContainsIi "54" $1; then
		export $2=11
	elif checkStringContainsIi "53" $1; then
		export $2=11
	elif checkStringContainsIi "52" $1; then
		export $2=8
	else
		export $2=8
	fi
}

function checkPkgJavaVersion {
	if ! [[ -n $2 ]]; then
		return 1
	fi

	if ! [[ -f $1 ]]; then
		return 1
	fi

	checkPkgMajorVersion $1 MAJOR_VERSION
	if [[ $? != 0 ]]; then
		return 1
	fi

	majorToJavaVersion ${MAJOR_VERSION} $2
	if [[ $? != 0 ]]; then
		return 1
	fi

	return 0
}
