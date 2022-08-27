#!/usr/bin/env bash

#Author:Maouai233
#version:2.4-rebuild-20220807
#Created Time:2022/08/07
#script Description:Install a server of Minecraft,there are more surprises in this script!Script may have some bugs,but to use is no problem.

export __SCRIPT_SIGN_VERSION__=24

ScriptClose() {
	rm -rf /tmp/McServer

	if [[ -f Check.sh ]]; then
		rm -rf Check.sh
	fi

	if [[ -f Config.sh ]]; then
		rm -rf Config.sh
	fi

	if [[ $1 == "ErrorExit" ]]; then
		exit 1
	elif [[ $1 == "Normal" ]]; then
		exit 0
	fi
}

ScriptExitF() {
	echo -e "\033[31m\n[ Script Exit - Errors ]\n\033[0m"
	busybox cat $1
	ScriptClose ErrorExit
}

ScriptExitFMsg() {
	echo -e "\033[31m\n[ Script Exit - Errors ]\n\033[0m"
	echo $1
	ScriptClose ErrorExit
}

function GetSu() {
	sudo true
}

function JavaCheck() {
	java getVersion
	return $?
}

JavaGetVersion() {
	JAVA_VERSION=$(java getVersion)
}

function AxelCheck() {
	axel --version
	return $?
}

function ScreenCheck() {
	which screen
	return $?
}

function BusyboxCheck() {
	busybox echo >/dev/null
	return $?
}

function IptablesCheck() {
	which iptables >/dev/null
	return $?
}

GetTime() {
	LANG=en.UTF-8 date +"%a %b %d %T %Z %Y"
}

CheckerInstaller() {
	echo -n "Updating the Software list..."
	sudo apt update >/tmp/McServer/Apt_Update 2>&1
	if [[ $? == 0 ]]; then
		PrintGreen "done"
	else
		PrintRed "Error"
		ScriptExitF /tmp/McServer/Apt_Update
	fi

	if [[ ${_AXEL} == 1 ]]; then
		echo -n "Installing Axel..."
		sudo apt-get install axel -y >/tmp/McServer/AxelInstall 2>&1
		if [[ $? != 0 ]]; then
			PrintRed "Error"
			ScriptExitF /tmp/McServer/AxelInstall
		fi
	fi

	if [[ ${_BUSYBOX} == 1 ]]; then
		echo -n "Installing busybox..."
		sudo apt-get install busybox -y >/tmp/McServer/BusyboxInstall 2>&1
		if [[ $? != 0 ]]; then
			PrintRed "Error"
			exit 1
		fi
	fi
}

function JavaGetBinaryPath {
	echo -n "Get Java Binary Path..."
	JAVA_BINARY_PATH=$(update-alternatives --list java | grep ${JAVA_INSTALL_VERSION} 2>&1)
	if [[ $? != 0 ]]; then
		echo ${JAVA_BINARY_PATH} >/tmp/McServer/JavaGetBinaryPathError
		ScriptExitF /tmp/McServer/JavaGetBinaryPathError
	fi
	PrintGreen "done"
	echo -n "Java Binary Path..."
	PrintBlue "${JAVA_BINARY_PATH}"
}

function JavaInstaller {
	if [[ ${JAVA_VERSION} == ${JAVA_INSTALL_VERSION} ]]; then
		echo "The Java will use has Installed Already."
		return 0
	fi

	if [[ ${_JAVA} != 0 ]] || [[ ${JAVA_VERSION} != ${JAVA_INSTALL_VERSION} ]]; then
		sudo apt-get install openjdk-${JAVA_INSTALL_VERSION}-jdk -y >/tmp/McServer/Apt_Install_Java 2>&1
		if [[ $? != 0 ]]; then
			ScriptExitF /tmp/McServer/Apt_Install_Java
		fi
	fi

	return 0
}

Checker() {
	#	mkfifo /tmp/Sign.in /tmp/Sign.out
	echo "User:${USER}"
	echo "Dir :$(pwd)"
	if [[ $(pwd) == '/' ]]; then
		ScriptExitFMsg "Can't Execute in /,Becase of Danger."
	fi

	SCRIPT_HOME=$(pwd)
	echo "Script Home...${SCRIPT_HOME}"

	echo -n "Loading Modules..."
	source ./output.sh
	source ./checkPkgVersion.sh
	PrintGreen "done"

	echo "Checking Softwares..."
	echo -n "Java..."
	if JavaCheck >/dev/null 2>&1; then
		PrintGreen "yes"
		JavaGetVersion
		echo -n "Java Version..."
		PrintGreen "${JAVA_VERSION}"
	else
		PrintRed "no"
		_JAVA=1
	fi

	echo -n "Axel..."
	if AxelCheck >/dev/null 2>&1; then
		PrintGreen "yes"
	else
		PrintRed "no"
		_AXEL=1
	fi

	echo -n "Busybox..."
	if BusyboxCheck; then
		PrintGreen "yes"
	else
		PrintRed "no"
		_BUSYBOX=1
	fi

	echo -n "Screen..."
	if ScreenCheck >/dev/null 2>&1; then
		PrintGreen "yes"
	else
		PrintRed "no"
		_SCREEN=1
	fi

	echo -n "Iptables[Check Only]..."
	if IptablesCheck; then
		PrintGreen "yes"
	else
		PrintRed "no"
		_IPTABLES=1
	fi

	echo -n "Creating the Directory Tmp..."
	if [[ ! -d "/tmp/McServer" ]]; then
		mkdir -p /tmp/McServer
		PrintGreen "done"
	else
		rm -rf /tmp/McServer/*
		PrintGreen "the directory has Created Already"
	fi

	echo -n "Creating Server Directory..."
	if [[ ! -d "McServer" ]]; then
		mkdir McServer >/tmp/McServer/EnvironmentError
		if [[ $? != 0 ]]; then
			echo "Permeission Denied" >>/tmp/McServer/EnvironmentError
			ScriptExitF /tmp/McServer/EnvironmentError
		fi
		PrintGreen "done"
	else
		PrintGreen "the directory has Created Already"
	fi
	SERVER_WORKING_DIR=$(realpath ./McServer)
	echo -n "Server Working Home..."
	PrintGreen "${SERVER_WORKING_DIR}"

	echo -n "Time..."
	PrintGreen "$(GetTime)"

	CheckerInstaller
}

function EulaCreate() {
	busybox cat >eula.txt <<EOF
#By changing the setting below to TRUE you are indicating your agreement to our EULA (http://account.mojang.com/documents/minecraft_eula).
#$(GetTime)
eula=true
EOF
}

function ServersettingCreate() {
	busybox cat >server.properties <<EOF
#Minecraft server properties
#$(GetTime)
generator-settings=
op-permission-level=4
allow-nether=${ALLOW_NETHER_ENABLE}
level-name=${LEVEL_NAME}
enable-query=false
allow-flight=${FLIGHT_ENABLE}
announce-player-achievements=true
server-port=${SERVER_PORT}
level-type=${LEVEL_TYPE}
enable-rcon=false
level-seed=${WORLD_SEED}
force-gamemode=${FORCE_GAME_MODE}
server-ip=
max-build-height=256
spawn-npcs=true
white-list=false
spawn-animals=${SPAWN_ANIMALS_ENABLE}
hardcore=${HARDCORE_MODE_ENABLE}
snooper-enabled=true
online-mode=${ONLINE_MODE_ENABLE}
resource-pack=
pvp=${PVP_ENABLE}
difficulty=${DIFFICULTY_LEVEL}
enable-command-block=${COMMAND_BLOCK_ENABLE}
gamemode=${GAMDMODE}
player-idle-timeout=0
max-players=${MAX_PLAYERS}
spawn-monsters=${SPAWN_MONSTER_ENABLE}
generate-structures=true
view-distance=10
motd=A Minecraft Server
EOF
}

function JarRunTest {
	echo -n "Making a Script for Checking the Jar of Minecraft Server..."
	cat >Check.sh <<EOF
#!/usr/bin/env bash
SCRIPT_HOME=${SCRIPT_HOME}
source ${SCRIPT_HOME}/checkString.sh
source ${SCRIPT_HOME}/tools.sh
source ${SCRIPT_HOME}/checkPkgVersion.sh
Return=\`LANG= java -jar ${SCRIPT_HOME}/McServer/server.jar nogui 2>&1\`
if [[ \$(echo \${Return} | grep Error | wc -l) -gt 0  ]] || [[ \$? != 0 ]];then
	if ! checkStringNull "\$(echo \${Return} | grep class | grep version)";then
		ClassVersionNum=\$(echo \${Return}|tr ' ' '\n'|grep -E "[[:digit:]]*\.[[:digit:]]"|awk -F '.' '{print \$1}'|tr '\n' ' ')
		numFindMax "\${ClassVersionNum}" ClassVersionNumMax
		majorToJavaVersion "\${ClassVersionNumMax}" JAVA_INSTALL_VERSION
		echo -e "#!/usr/bin/env bash" > /tmp/McServer/Jar_Run_Test_Var.sh
		echo -e "JAVA_INSTALL_VERSION=\${JAVA_INSTALL_VERSION}" >> /tmp/McServer/Jar_Run_Test_Var.sh
	elif ! checkStringNull "\$(echo \${Return} | grep Unsupported|grep -i to)";then
		JavaVersionNum=\$(echo \${Return} |tr ' ' '\n'|grep -E '^[[:digit:]]{1,}')
		numFindMin "\${JavaVersionNum}" JavaMaxVersionNumMin
		if [[ \${JavaMaxVersionNumMin} -ge 11 ]] && [[ \${JavaMaxVersionNumMin} -le 16 ]] && update-alternatives --list java|grep "\-11\-";then
			JAVA_INSTALL_VERSION=11
		elif [[ \${JavaMaxVersionNumMin} -ge 8 ]] && [[ \${JavaMaxVersionNumMin} -le 11 ]] && update-alternatives --list java|grep "\-8\-";then
			JAVA_INSTALL_VERSION=8
		else
			if [[ \${JavaMaxVersionNumMin} -ge 11 ]] && [[ \${JavaMaxVersionNumMin} -le 16 ]];then
				JAVA_INSTALL_VERSION=11
			elif [[ \${JavaMaxVersionNumMin} -ge 8 ]] && [[ \${JavaMaxVersionNumMin} -le 11 ]];then
				JAVA_INSTALL_VERSION=8
			fi
		fi
		echo -e "#!/usr/bin/env bash" > /tmp/McServer/Jar_Run_Test_Var.sh
		echo -e "JAVA_INSTALL_VERSION=\${JAVA_INSTALL_VERSION}" >> /tmp/McServer/Jar_Run_Test_Var.sh
	elif ! checkStringNull "\$(echo \${Return} | grep -i eula)";then
		echo "TRUE"
	else
		echo -e "Java Returned:\${Return}\nThe Jar is broken" > /tmp/McServer/Jar_Run_Test_Error
    fi
fi
rm -rf ./eula.txt ./logs/* ./world_* ./*.yml *.json ./plugins
exit
EOF
	PrintGreen "done"
	echo -n "Start to Check the Jar File..."
	screen -dmS JarCheckTerm bash ./Check.sh
	sleep 6
	if [[ -f "/tmp/McServer/Jar_Run_Test_Error" ]]; then
		PrintRed "Error"
		return 1
	else
		processNum=$(ps -fe | grep server.jar | grep java | grep -v "grep" | grep -v "CheckJarTerm" | awk '{print $2}')
		if ! checkStringNull checkStringNull ${processNum}; then
			kill -9 $processNum >/dev/null 2>&1
		fi
	fi
	PrintGreen "done"

	return 0
}

McServerChoose() {
	while true; do
		echo "--------------------------------"
		echo -e "1.18.2  1.18.1  1.18 \n1.17.1  1.17    1.16.5\n1.16.4  1.16.3  1.16.2\n1.16.1  1.15.2  1.15.1\n1.15    1.14.4  1.14.3\n1.14.2  1.14.1  1.14\n1.13.2  1.13.1  1.13\n1.12.2  1.12.1  1.12\n1.11.2  1.11.1  1.10.2\n1.10    1.9.4   1.9.2\n1.9     1.8.8   1.8.7\n1.8.6   1.8.5   1.8.4\n1.8.3   1.8     1.7.10\n1.7.9   1.7.8   1.7.5\n1.7.2   1.6.4   1.6.2\n1.5.2   1.5.1   1.4.7\n1.4.6\n Choose My Local Jar Pkg(r)"
		echo "--------------------------------"
		local InputVersion
		read -p "Enter the MC Server Version that You want to Install:" InputVersion
		case ${InputVersion} in
		"1.18.2")
			SERVER_JAR_PATH="http://download.getbukkit.org/spigot/spigot-1.18.2.jar"
			JAVA_INSTALL_VERSION_GROUP=(17)
			JAR_MD5="0b28293f53c78aa75c2f0eab3fe671fc" # spigot-1.18.2.jar
			;;
		"1.18.1")
			SERVER_JAR_PATH="http://download.getbukkit.org/spigot/spigot-1.18.1.jar"
			JAVA_INSTALL_VERSION_GROUP=(17)
			JAR_MD5="47a8e718a1d15b3ed863fc57b35a7261" # spigot-1.18.1.jar
			;;
		"1.18")
			SERVER_JAR_PATH="http://download.getbukkit.org/spigot/spigot-1.18.jar"
			JAVA_INSTALL_VERSION_GROUP=(17)
			JAR_MD5="6c1278a241a7b160058acd50a96293d3" # spigot-1.18.jar
			;;
		"1.17.1")
			SERVER_JAR_PATH="http://download.getbukkit.org/spigot/spigot-1.17.1.jar"
			JAVA_INSTALL_VERSION_GROUP=(17)
			JAR_MD5="c5d29ac5ee0e931aefa722e5268f53cb" # spigot-1.17.1.jar
			;;
		"1.17")
			SERVER_JAR_PATH="http://download.getbukkit.org/spigot/spigot-1.17.jar"
			JAVA_INSTALL_VERSION_GROUP=(17)
			JAR_MD5="e7208a2680692d1b42a9baf3ab93a7f0" # spigot-1.17.jar
			;;
		"1.16.5")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.16.5.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="8a29bd9d52a19c09ba8856cacdc137ab" # spigot-1.16.5.jar
			;;
		"1.16.4")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.16.4.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="b451ff7cca476850f3873bcae8395c30" # spigot-1.16.4.jar
			;;
		"1.16.3")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.16.3.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="80846e51ee42dac24276cb30e05f7b3c" # spigot-1.16.3.jar
			;;
		"1.16.2")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.16.2.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="f7a606956c49b0f745d2e17d233dcc1e" # spigot-1.16.2.jar
			;;
		"1.16.1")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.16.1.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="63591079d1366b808433a9a9c8540ac8" # spigot-1.16.1.jar
			;;
		"1.15.2")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.15.2.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="06ab040f4d939b90608b8714ea12cbfe" # spigot-1.15.2.jar
			;;
		"1.15.1")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.15.1.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="eb599786409409acfd1dda3ec590f5a1" # spigot-1.15.1.jar
			;;
		"1.15")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.15.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="583b48a371bc250f67d99d4509196e0f" # spigot-1.15.jar
			;;
		"1.14.4")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.14.4.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="f47b0fc2cebae5a1ef6b9e187160df52" # spigot-1.14.4.jar
			;;
		"1.14.3")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.14.3.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="9b73dae7e8799f81f085b4b4b2b492cd" # spigot-1.14.3.jar
			;;
		"1.14.2")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.14.2.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="e35e46a6ff72631e2d11aff070ce72db" # spigot-1.14.2.jar
			;;
		"1.14.1")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.14.1.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="c86ae3aa0128b67982c4452cb0f1efe8" # spigot-1.14.1.jar
			;;
		"1.14")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.14.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="ca70fe8f8275db1c26b50482a613481b" # spigot-1.14.jar
			;;
		"1.13.2")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.13.2.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="771f35742240446e60dcce53479b632c" # spigot-1.13.2.jar
			;;
		"1.13.1")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.13.1.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="7d890aedfbe471e299ed595e49050e4d" # spigot-1.13.1.jar
			;;
		"1.13")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.13.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="f6514628a7c5ce2d7d4848902dbc8d0d" # spigot-1.13.jar
			;;
		"1.12.2")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.12.2.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="2144278a07581eca65308e0beecbcc0b" # spigot-1.12.2.jar
			;;
		"1.12.1")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.12.1.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="c9323a37b1fcf3e4100d894ab625836e" # spigot-1.12.1.jar
			;;
		"1.12")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.12.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="d65128bf43a587522fac2fef31cc9a15" # spigot-1.12.jar
			;;
		"1.11.2")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.11.2.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="13a913072b109f4ecabe60a786f1ab1b" # spigot-1.11.2.jar
			;;
		"1.11.1")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.11.1.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="d48fc7b792aeae45725af6ec112efa92" # spigot-1.11.1.jar
			;;
		"1.11")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.11.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="b636af42a194fa2ec61bb436ed8db2de" # spigot-1.11.jar
			;;
		"1.10.2")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.10.2-R0.1-SNAPSHOT-latest.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="465416bc0b0b24795f53a163c47a2724" # spigot-1.10.2-R0.1-SNAPSHOT-latest.jar
			;;
		"1.10")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.10-R0.1-SNAPSHOT-latest.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="c488d3d5485c4b95c7d4c62d23ab079c" # spigot-1.10-R0.1-SNAPSHOT-latest.jar
			;;
		"1.9.4")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.9.4-R0.1-SNAPSHOT-latest.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="faba2cc7fe94ab145eafd02f2d8c23ae" # spigot-1.9.4-R0.1-SNAPSHOT-latest.jar
			;;
		"1.9.2")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.9.2-R0.1-SNAPSHOT-latest.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="a787ff792e619269d2bf74944b84b585" # spigot-1.9.2-R0.1-SNAPSHOT-latest.jar
			;;
		"1.9")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.9-R0.1-SNAPSHOT-latest.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="ac80295c9f9c0dbf0ba6a0687e9f266f" # spigot-1.9-R0.1-SNAPSHOT-latest.jar
			;;
		"1.8.8")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.8.8-R0.1-SNAPSHOT-latest.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="31c41aadd504bdf9d451a716fe4b335e" # spigot-1.8.8-R0.1-SNAPSHOT-latest.jar
			;;
		"1.8.7")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.8.7-R0.1-SNAPSHOT-latest.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="ddb90a9326fa1e73927ac0523245d3a1" # spigot-1.8.7-R0.1-SNAPSHOT-latest.jar
			;;
		"1.8.6")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.8.6-R0.1-SNAPSHOT-latest.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="6153c37acd914622825e58dbcd0c3533" # spigot-1.8.6-R0.1-SNAPSHOT-latest.jar
			;;
		"1.8.5")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.8.5-R0.1-SNAPSHOT-latest.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="f3a8b0e74f8aec6883ceac70e92ee8f4" # spigot-1.8.5-R0.1-SNAPSHOT-latest.jar
			;;
		"1.8.4")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.8.4-R0.1-SNAPSHOT-latest.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="9c2cbcc7131f21b5d2cf508ded9291d6" # spigot-1.8.4-R0.1-SNAPSHOT-latest.jar
			;;
		"1.8.3")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.8.3-R0.1-SNAPSHOT-latest.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="f27e2abfc24a25caae898e8e2239420a" # spigot-1.8.3-R0.1-SNAPSHOT-latest.jar
			;;
		"1.8")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.8-R0.1-SNAPSHOT-latest.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="dbca961b1d64a6340368bfc3c83e8168" # spigot-1.8-R0.1-SNAPSHOT-latest.jar
			;;
		"1.7.10")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.7.10-SNAPSHOT-b1657.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="870c9021be261bd285c966c642b23c32" # spigot-1.7.10-SNAPSHOT-b1657.jar
			;;
		"1.7.9")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.7.9-R0.2-SNAPSHOT.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="727ba618de158aefaf403bb455771ede" # spigot-1.7.9-R0.2-SNAPSHOT.jar
			;;
		"1.7.8")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.7.8-R0.1-SNAPSHOT.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="7e2e6bb626013368b134212a5ec76aa1" # spigot-1.7.8-R0.1-SNAPSHOT.jar
			;;
		"1.7.5")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.7.5-R0.1-SNAPSHOT-1387.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="76ad1a9809a014d3adc70ad39fb8e610" # spigot-1.7.5-R0.1-SNAPSHOT-1387.jar
			;;
		"1.7.2")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.7.2-R0.4-SNAPSHOT-1339.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="6685f2f76bf77e4db785fb32edbd313c" # spigot-1.7.2-R0.4-SNAPSHOT-1339.jar
			;;
		"1.6.4")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.6.4-R2.1-SNAPSHOT.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="b3c3ea5ac57d74288210a6f4bf712a3c" # spigot-1.6.4-R2.1-SNAPSHOT.jar
			;;
		"1.6.2")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.6.2-R1.1-SNAPSHOT.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="16949faf15a17005a32a8048944e7dd3" # spigot-1.6.2-R1.1-SNAPSHOT.jar
			;;
		"1.5.2")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.5.2-R1.1-SNAPSHOT.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="3f7612fe14733afff548cf6a2c8109fb" # spigot-1.5.2-R1.1-SNAPSHOT.jar
			;;
		"1.5.1")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.5.1-R0.1-SNAPSHOT.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="74dbb8b77caa1f2f8941a3229f51fba9" # spigot-1.5.1-R0.1-SNAPSHOT.jar
			;;
		"1.4.7")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.4.7-R1.1-SNAPSHOT.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="ca2660dd58595706662c3789697f2eec" # spigot-1.4.7-R1.1-SNAPSHOT.jar
			;;
		"1.4.6")
			SERVER_JAR_PATH="http://cdn.getbukkit.org/spigot/spigot-1.4.6-R0.4-SNAPSHOT.jar"
			JAVA_INSTALL_VERSION_GROUP=(11 8)
			JAR_MD5="28898bbf7f917f7a97d2db7edf1bb7cb" # spigot-1.4.6-R0.4-SNAPSHOT.jar
			;;
		'r')
			if ! [[ -f McServer/server.jar ]]; then
				echo "Please Move the Target Jar to the Directory - McServer,and Rename it to \"server.jar\"."
				ScriptClose Normal
			fi
			;;
		esac

		if ! [[ -n ${InputVersion} ]]; then
			echo "Please Enter!"
		elif ! [[ -n ${SERVER_JAR_PATH} ]]; then
			echo "The Version you Entered is Invalid."
		else
			break
		fi
	done
}

AxelDownload() {
	echo "--------------"
	echo "Start to Download Server Jar File With Axel ..."
	axel -n 32 -o server.jar ${SERVER_JAR_PATH} 2>/tmp/McServer/AxelDownloadError
	if [[ $? == 0 ]]; then
		PrintGreen "--------------"
	else
		ScriptExitF /tmp/McServer/AxelDownloadError
	fi
}

Md5Check() {
	echo -n "Checking File use Md5..."
	if [[ $(busybox md5sum server.jar | awk '{print $1}') != ${JAR_MD5} ]]; then
		echo "Error in Md5,Maybe The File is Broken." >/tmp/McServer/Md5Error
		ScriptExitF /tmp/McServer/Md5Error
	fi
	PrintGreen "done"
}

#################################################################
#################################################################

Configure() {
	echo "Start to Configure by Yourself..."

	echo -e "\n"
	echo "--------------"
	echo "By changing the setting below to TRUE you are indicating your agreement to our EULA (http://account.mojang.com/documents/minecraft_eula)".
	echo $(GetTime)
	echo "--------------"
	echo "Just so you know, by downloading any of the software on this page, you agree to theMinecraft End User License AgreementandPrivacy Policy."
	echo "--------------"

	while true; do
		read -p "Agree( y/n )|" eulaAngreeYoN
		if [[ ${eulaAngreeYoN} == 'y' ]]; then
			EulaCreate
			break
		fi
	done

	echo "--------------"
	while true; do
		echo "Please Enter the Port Number of the Server | 1024-65535 | Num"
		read -p ">" SERVER_PORT
		if checkStringClassContains 0-9 "${SERVER_PORT}"; then
			SERVER_PORT=$(expr ${SERVER_PORT} + 0)
			if [[ ${SERVER_PORT} -le 65535 ]] && [[ ${SERVER_PORT} -ge 1024 ]]; then
				if lsof -i :${SERVER_PORT} >/dev/null 2>&1; then
					PrintBlue "${SERVER_PORT} the Port has been taken [ PID: $(lsof -i :${SERVER_PORT} | awk 'NR==2 {print $2}') ]"
					continue
				fi

				# if [[ ${SERVER_PORT} -le 1023 ]]; then
				# 	_SUDO_PREFIX_EXEC="sudo"
				# fi

				break
			else
				PrintBlue "Please Enter a Positive Integer from 1024 to 65535 as the Server Port!"
			fi
		else
			PrintBlue "Please Enter a Positive Integer!"
		fi
	done

	echo "--------------"
	while true; do
		echo "Please Enter the Minimum Memory that Java(or Server) can use to Keep Server Running Successfully|Positive Integer"
		read -p ">" MemoryJvmXms
		if [[ ${MemoryJvmXms} -gt 0 ]]; then
			break
		else
			PrintBlue "Please Enter a Positive Integer!"
		fi
	done

	echo "--------------"
	while true; do
		echo "Please Enter the Maximum Memory|Positive Integer"
		read -p ">" MemoryJvmXmx
		if [[ ${MemoryJvmXms} -gt 0 ]]; then
			if [[ ${MemoryJvmXms} -gt ${MemoryJvmXmx} ]]; then
				PrintBlue "The Maximum Memory number Must be More than the Minimum Memory number,the Result you enter was so Strange! Σ(っ °Д °;)っ"
				continue
			fi
			break
		else
			PrintBlue "Please Enter a Positive Integer!"
		fi
	done

	echo "--------------"
	while true; do
		echo "Please Enter the Name of The Server you want|the Commoner,the few Bugs there will be|e.g. world"
		read -p ">" LEVEL_NAME
		if ! checkStringNull "${LEVEL_NAME}"; then
			break
		else
			PrintBlue "The Name mustn't be NULL,Again Please...QwQ"
		fi
	done

	echo "--------------"
	while true; do
		echo "Please Enter the World Seed"
		read -p ">" WORLD_SEED
		if [[ $(echo ${WORLD_SEED} | wc -l) -gt 0 ]]; then
			#		if grep -E '[0-9a-zA-Z\+\-]' <<< "${WORLD_SEED}"; then
			break
		else
			PrintBlue "Please Compelete it Correctly!"
			# PrintBlue "Please Enter a Positive Integer"
		fi
	done

	echo "--------------"
	while true; do
		echo "Please Enter the Class of the World|Normal-n|Flat-f|Large Biomes-l"
		read -p ">" LevelType
		if [[ ${LevelType} == 'n' ]]; then
			LEVEL_TYPE="minecraft:normal"
			break
		elif [[ ${LevelType} == 'f' ]]; then
			LEVEL_TYPE="minecraft:flat"
			break
		elif [[ ${LevelType} == 'l' ]]; then
			LEVEL_TYPE="minecraft:large_biomes"
			break
		fi
	done

	echo "--------------"
	while true; do
		echo "Do you want to create a BonusChest when the World Creating |y / n|"
		read -p ">" BonusChestYoN
		if [[ ${BonusChestYoN} == 'y' ]]; then
			CONFIG_JAVA_OPTION="${CONFIG_JAVA_OPTION} -bonusChest"
			break
		fi
	done

	echo "--------------"
	while true; do
		echo "Default Server Game Mode|Survival-0|Creative-1|Adventure-2|Spectator-3|Hardcore-h"
		read -p ">" GAMDMODE
		if [[ ${GAMDMODE} == '0' ]] || [[ ${GAMDMODE} == '1' ]] || [[ ${GAMDMODE} == '2' ]] || [[ ${GAMDMODE} == '3' ]]; then
			break
		elif [[ ${GAMDMODE} == 'h' ]]; then
			HARDCORE_MODE_ENABLE="true"
			break
		else
			PrintBlue "Please Compelete it Successfully!"
		fi
	done

	echo "--------------"
	while true; do
		echo "Are Players Forced to Change them GameMode to the Default After Entering the Server? |y / n|"
		read -p ">" ForceGamemodeYoN
		if [[ ${ForceGamemodeYoN} == 'y' ]]; then
			FORCE_GAME_MODE="true"
			break
		elif [[ ${ForceGamemodeYoN} == 'n' ]]; then
			FORCE_GAME_MODE="false"
			break
		fi
	done

	echo "--------------"
	if [[ ${HARDCORE_MODE_ENABLE} == "true" ]]; then
		echo "The Difficulty Hard can't change Becase of Hardcore Mode."
		DIFFICULTY_LEVEL=3
	else
		while true; do
			echo "Please Enter the Defalut Server Game Difficulty Mode |Peaceful-0|Easy-1|Normal-2|Hard-3"
			read -p ">" DIFFICULTY_LEVEL
			if [[ ${DIFFICULTY_LEVEL} == '0' ]] || [[ ${DIFFICULTY_LEVEL} == '1' ]] || [[ ${DIFFICULTY_LEVEL} == '2' ]] || [[ ${DIFFICULTY_LEVEL} == '3' ]]; then
				break
			fi
		done
	fi

	echo "--------------"
	while true; do
		echo "Please Enter the Server's Max Num of Playing Players | Positive Integer 1-2147483647"
		read -p ">" MAX_PLAYERS
		if checkStringClassContains 0-9 ${MAX_PLAYERS}; then
			if [[ ${MAX_PLAYERS} -gt 0 ]]; then
				if [[ ${MAX_PLAYERS} -le 2147483647 ]]; then
					break
				else
					PrintBlue "Beyond Range..."
				fi
			else
				PrintBlue "Invalid Number."
			fi
		fi
	done

	echo "--------------"
	while true; do
		echo "Allow PvP |y / n| "
		read -p ">" PvpYoN
		if [[ ${PvpYoN} == 'y' ]]; then
			PVP_ENABLE="true"
			break
		elif [[ ${PvpYoN} == 'n' ]]; then
			PVP_ENABLE="false"
			break
		fi
	done

	echo "--------------"
	while true; do
		echo "Allow Players Fly with Server Plugins or MOD and More |y / n|"
		read -p ">" FlightYoN
		if [[ ${FlightYoN} == 'y' ]]; then
			FLIGHT_ENABLE="true"
			break
		elif [[ ${FlightYoN} == 'n' ]]; then
			FLIGHT_ENABLE="false"
			break
		fi
	done

	echo "--------------"
	while true; do
		echo "Allow Players Enter the Nether and the Nether will be valid |y / n|"
		read -p ">" AllowNetherYoN
		if [[ ${AllowNetherYoN} == 'y' ]]; then
			ALLOW_NETHER_ENABLE="true"
			break
		elif [[ ${AllowNetherYoN} == 'n' ]]; then
			ALLOW_NETHER_ENABLE="false"
			break
		fi
	done

	echo "--------------"
	while true; do
		echo "Enable Online Mode |y / n|"
		read -p ">" OnlineModeYoN
		if [[ ${OnlineModeYoN} == 'y' ]]; then
			ONLINE_MODE_ENABLE="true"
			break
		elif [[ ${OnlineModeYoN} == 'n' ]]; then
			ONLINE_MODE_ENABLE="flase"
			break
		fi
	done

	echo "--------------"
	while true; do
		echo "Enable Command_Block |y / n|"
		read -p ">" CommandBlockYoN
		if [[ ${CommandBlockYoN} == 'y' ]]; then
			COMMAND_BLOCK_ENABLE="true"
			break
		elif [[ ${CommandBlockYoN} == 'n' ]]; then
			COMMAND_BLOCK_ENABLE="flase"
			break
		fi
	done

	echo "--------------"
	while true; do
		echo "Enable Generating Monsters |y / n|"
		read -p ">" SpawnMonstersYoN
		if [[ ${SpawnMonstersYoN} == 'y' ]]; then
			SPAWN_MONSTER_ENABLE="true"
			break
		elif [[ ${SpawnMonstersYoN} == 'n' ]]; then
			SPAWN_MONSTER_ENABLE="false"
			break
		fi
	done

	echo "--------------"
	while true; do
		echo "Please Enter a String as the Path of the Starting Script Home,the Script will be Created in the Directory that the Path points | e.g. /root/"
		read -p ">" ShFDir
		ShFDir=$(echo ${ShFDir} | awk ' {print $1} ') #始终使用服主输入的第一个路径
		if ! mkdir -p ${ShFDir} >/dev/null 2>&1; then
			_SUDO_PREFIX="sudo"
			$_SUDO_PREFIX mkdir -p ${ShFDir}
		fi

		if [[ -d ${ShFDir} ]]; then
			break
		fi
	done

	echo -n "Export Config [server.properties]..."
	ServersettingCreate
	PrintGreen "done"

	echo -n "Creating Starting Script..."
	if ! touch ${ShFDir}/start.sh >/dev/null 2>&1; then
		_SUDO_PREFIX="sudo"
	fi

	cat ${SCRIPT_HOME}/output.sh | sudo tee ${ShFDir}/start.sh >${SCRIPT_HOME}/start.sh
	echo "SERVER_WORKING_DIR=${SERVER_WORKING_DIR}" | sudo tee -a ${ShFDir}/start.sh >>${SCRIPT_HOME}/start.sh
	echo "JAVA_BINARY_PATH=${JAVA_BINARY_PATH}" | sudo tee -a ${ShFDir}/start.sh >>${SCRIPT_HOME}/start.sh
	echo "MemoryJvmXmx=${MemoryJvmXmx}" | sudo tee -a ${ShFDir}/start.sh >>${SCRIPT_HOME}/start.sh
	echo "MemoryJvmXms=${MemoryJvmXms}" | sudo tee -a ${ShFDir}/start.sh >>${SCRIPT_HOME}/start.sh
	cat ${SCRIPT_HOME}/startScriptEn.sh | sudo tee -a ${ShFDir}/start.sh >>${SCRIPT_HOME}/start.sh

	$_SUDO_PREFIX chmod +x ${ShFDir}/start.sh
	$_SUDO_PREFIX chown ${USER}: ${ShFDir}/start.sh
	$_SUDO_PREFIX chmod +x ${SCRIPT_HOME}/start.sh
	$_SUDO_PREFIX chown ${USER}: ${SCRIPT_HOME}/start.sh

	PrintGreen "done"
	echo "Created Starting Script in ${ShFDir} [ start.sh ]"

	echo -n "Creating the Configure Script..."
	cat >Config.sh <<EOF
${JAVA_BINARY_PATH} -Xms${MemoryJvmXms}m -Xmx${MemoryJvmXmx}m -jar ./server.jar nogui
exit
EOF
	PrintGreen "done"

	echo -n "Start to Configure use Script and Apply..."
	screen -dmS ConfigTerm bash ./Config.sh

	while ! [[ -f "logs/latest.log" ]]; do
		echo -n "."
		sleep 1
	done

	processNum=$(ps -fe | grep server.jar | grep java | grep -v grep | awk '{print $2}')
	while true; do
		echo -n "."
		if busybox cat logs/latest.log | grep help | grep INFO | grep Done >/dev/null 2>&1; then
			kill -9 ${processNum} 2>/dev/null
			break
		fi

		if ! ps -fe | grep server.jar | grep java | grep -v grep >/dev/null 2>&1; then
			echo "Maybe There is an Error" >/tmp/McServer/Config_Java_Run_Error
			ScriptExitF /tmp/McServer/Config_Java_Run_Error
		fi
		sleep 1
	done
	PrintGreen "done"
}
#################################################################

function ScriptUpdateMessage {
	echo ""
}

function NormalStart {
	cd McServer
	McServerChoose
	AxelDownload
	Md5Check

	for JavaVersionIdx in "${JAVA_INSTALL_VERSION_GROUP[@]}"; do
		if update-alternatives --list java | grep ${JavaVersionIdx} >>/dev/null 2>&1; then
			JAVA_INSTALL_VERSION=${JavaVersionIdx}
			break
		fi
	done
	if ! [[ $(wc -w <<<${JAVA_INSTALL_VERSION} 2>&1) -gt 0 ]]; then
		JAVA_INSTALL_VERSION=${JAVA_INSTALL_VERSION_GROUP[0]}
	fi
	echo "Java Version Redirects to:${JAVA_INSTALL_VERSION}"
	echo "Start Running JavaInstaller..."
	JavaInstaller
	JavaGetBinaryPath
	Configure
}

function JarStart {
	echo "Check the Java Verion that the Jar will Use..."
	checkPkgJavaVersion ./McServer/server.jar JAVA_INSTALL_VERSION 2>/tmp/McServer/check_JarVersion
	if [[ $? != 0 ]]; then
		echo "The File May not be a Jar." >>/tmp/McServer/check_JarVersion
		ScriptExitF /tmp/McServer/check_JarVersion
	fi
	echo -n "Java Version..."
	PrintGreen ${JAVA_INSTALL_VERSION}

	JavaInstaller

	cd McServer

	echo "Start ro Check Jar..."
	JarRunTest
	if [[ $? != 0 ]]; then
		ScriptExitF /tmp/McServer/Jar_Run_Test_Error
	fi
	if [[ -f "/tmp/McServer/Jar_Run_Test_Var.sh" ]]; then
		source /tmp/McServer/Jar_Run_Test_Var.sh
		echo "Java Version Redirects to:${JAVA_INSTALL_VERSION}"
		echo "Start Running JavaInstaller..."
		JavaInstaller
	fi

	JavaGetBinaryPath

	Configure
}

GetSu
clear
Checker
echo "--------------"
if [[ -f McServer/server.jar ]]; then
	if [[ -d McServer/logs ]]; then
		echo "There is a Server in Directory McServer/,Please Delete Those Files(except server.jar) or quit to cd to Another Directory and Continue."
		while true; do
			read -p "Delete(d);Quit(q) | " choose
			if [[ ${choose} = 'q' ]]; then
				ScriptClose Normal
			elif [[ ${choose} = 'd' ]]; then
				rm -rf $(ls McServer | grep -v "server.jar" | awk '{print "McServer/"$0}')
				break
			fi
		done
	fi

	echo "There is a File called \"server.jar\" in McServer/"
	while true; do
		read -p "Delete & Continue(d);Quit(q);Continue to use the Jar to Install(c) | " choose

		case ${choose} in
		'd')
			rm -rf ./McServer/*
			NormalStart
			break
			;;
		'q')
			ScriptClose Normal
			;;
		'c')
			JarStart
			break
			;;
		esac
	done
else
	NormalStart
fi
