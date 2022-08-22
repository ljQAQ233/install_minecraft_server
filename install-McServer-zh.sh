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
	echo -e "\033[31m\n[ 脚本紧急退出 - 错误 ]\n\033[0m"
	busybox cat $1
	ScriptClose ErrorExit
}

ScriptExitFMsg() {
	echo -e "\033[31m\n[ 脚本紧急退出 - 错误 ]\n\033[0m"
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
	echo -n "更新软件列表..."
	#	sudo apt update >/tmp/McServer/Apt_Update 2>&1
	if [[ $? == 0 ]]; then
		PrintGreen "完成"
	else
		PrintRed "错误"
		ScriptExitF /tmp/McServer/Apt_Update
	fi

	if [[ ${_AXEL} == 1 ]]; then
		echo -n "安装Axel..."
		sudo apt-get install axel -y >/tmp/McServer/AxelInstall 2>&1
		if [[ $? != 0 ]]; then
			PrintRed "失败"
			ScriptExitF /tmp/McServer/AxelInstall
		fi
	fi

	if [[ ${_BUSYBOX} == 1 ]]; then
		echo -n "安装busybox..."
		sudo apt-get install busybox -y >/tmp/McServer/BusyboxInstall 2>&1
		if [[ $? != 0 ]]; then
			PrintRed "失败"
			exit 1
		fi
	fi
}

function JavaGetBinaryPath {
	echo -n "获取Java可执行程序路径..."
	JAVA_BINARY_PATH=$(update-alternatives --list java | grep ${JAVA_INSTALL_VERSION} 2>&1)
	if [[ $? != 0 ]]; then
		echo ${JAVA_BINARY_PATH} >/tmp/McServer/JavaGetBinaryPathError
		ScriptExitF /tmp/McServer/JavaGetBinaryPathError
	fi
	PrintGreen "完成"
	echo -n "Java可执行程序路径..."
	PrintBlue "${JAVA_BINARY_PATH}"
}

function JavaInstaller {
	if [[ ${JAVA_VERSION} == ${JAVA_INSTALL_VERSION} ]]; then
		echo "所需的Java已安装."
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
	echo "用户:${USER}"
	echo "Dir :$(pwd)"
	if [[ $(pwd) == '/' ]]; then
		ScriptExitFMsg "不可在根目录 / 下执行."
	fi

	SCRIPT_HOME=$(pwd)
	echo "脚本目录...${SCRIPT_HOME}"

	echo -n "加载模块..."
	source ./output.sh
	source ./checkPkgVersion.sh
	PrintGreen "完成"

	echo "检测软件..."
	echo -n "Java..."
	if JavaCheck >/dev/null 2>&1; then
		PrintGreen yes
		JavaGetVersion
		echo -n "Java版本..."
		PrintGreen "${JAVA_VERSION}"
	else
		PrintRed no
		_JAVA=1
	fi

	echo -n "Axel..."
	if AxelCheck >/dev/null 2>&1; then
		PrintGreen yes
	else
		PrintRed no
		_AXEL=1
	fi

	echo -n "Busybox..."
	if BusyboxCheck; then
		PrintGreen yes
	else
		PrintRed no
		_BUSYBOX=1
	fi

	echo -n "Screen..."
	if ScreenCheck >/dev/null 2>&1; then
		PrintGreen yes
	else
		PrintRed no
		_SCREEN=1
	fi

	echo -n "Iptables[仅检查]..."
	if IptablesCheck; then
		PrintGreen yes
	else
		PrintRed no
		_IPTABLES=1
	fi

	echo -n "创建服务器目录..."
	if [[ ! -d "McServer" ]]; then
		mkdir McServer
		PrintGreen "完成"
	else
		PrintGreen "目录已存在"
	fi
	SERVER_WORKING_DIR=$(realpath ./McServer)
	echo -n "服务器工作目录..."
	PrintGreen "${SERVER_WORKING_DIR}"

	echo -n "创建Tmp目录..."
	if [[ ! -d "/tmp/McServer" ]]; then
		mkdir -p /tmp/McServer
		PrintGreen "完成"
	else
		rm -rf /tmp/McServer/*
		PrintGreen "目录已存在"
	fi

	GetTime
	echo "时间...${TIME}"

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
	echo -n "创建检验Jar脚本..."
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
		echo -e "Java 返回：\${Return}\nJar包可能已损坏" > /tmp/McServer/Jar_Run_Test_Error
    fi
fi
rm -rf ./eula.txt ./logs/* ./world_* ./*.yml *.json ./plugins
exit
EOF
	PrintGreen "完成"
	echo -n "开始校验Jar..."
	screen -dmS JarCheckTerm bash ./Check.sh
	sleep 6
	if [[ -f "/tmp/McServer/Jar_Run_Test_Error" ]]; then
		PrintRed "错误"
		return 1
	else
		processNum=$(ps -fe | grep server.jar | grep java | grep -v "grep" | grep -v "CheckJarTerm" | awk '{print $2}')
		if ! checkStringNull checkStringNull ${processNum}; then
			kill -9 $processNum >/dev/null 2>&1
		fi
	fi
	PrintGreen "完成"

	return 0
}

McServerChoose() {
	while true; do
		echo "--------------------------------"
		echo -e "1.18.2  1.18.1  1.18 \n1.17.1  1.17    1.16.5\n1.16.4  1.16.3  1.16.2\n1.16.1  1.15.2  1.15.1\n1.15    1.14.4  1.14.3\n1.14.2  1.14.1  1.14\n1.13.2  1.13.1  1.13\n1.12.2  1.12.1  1.12\n1.11.2  1.11.1  1.10.2\n1.10    1.9.4   1.9.2\n1.9     1.8.8   1.8.7\n1.8.6   1.8.5   1.8.4\n1.8.3   1.8     1.7.10\n1.7.9   1.7.8   1.7.5\n1.7.2   1.6.4   1.6.2\n1.5.2   1.5.1   1.4.7\n1.4.6\n 选择本地的Jar安装(r)"
		echo "--------------------------------"
		local InputVersion
		read -p "键入您想要安装的服务器版本:" InputVersion
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
				echo "请把Jar文件移入McServer目录，并重命名它为 \"server.jar\"。"
				ScriptClose Normal
			fi
			;;
		esac

		if ! [[ -n ${InputVersion} ]]; then
			echo "您没有输入任何版本号！"
		elif ! [[ -n ${SERVER_JAR_PATH} ]]; then
			echo "输入的版本号无效！"
		else
			break
		fi
	done
}

AxelDownload() {
	echo "--------------"
	echo "开始使用Axel下载服务端..."
	axel -n 32 -o server.jar ${SERVER_JAR_PATH} 2>/tmp/McServer/AxelDownloadError
	if [[ $? == 0 ]]; then
		PrintGreen "--------------"
	else
		ScriptExitF /tmp/McServer/AxelDownloadError
	fi
}

Md5Check() {
	echo -n "检测Md5..."
	if [[ $(busybox md5sum server.jar | awk '{print $1}') != ${JAR_MD5} ]]; then
		echo "Md5值错误，可能是文件损坏." >/tmp/McServer/Md5Error
		ScriptExitF /tmp/McServer/Md5Error
	fi
	PrintGreen "完成"
}

#################################################################
#################################################################

Configure() {
	echo "开始进行自定义配置..."

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
		echo "请输入服务器端口号 | 1024-65535 | 数字"
		read -p ">" SERVER_PORT
		if checkStringClassContains 0-9 "${SERVER_PORT}"; then
			SERVER_PORT=$(expr ${SERVER_PORT} + 0)
			if [[ ${SERVER_PORT} -le 65535 ]] && [[ ${SERVER_PORT} -ge 1024 ]]; then
				if lsof -i :${SERVER_PORT} >/dev/null 2>&1; then
					PrintBlue "${SERVER_PORT} 端口已被占用 [ PID: $(lsof -i :${SERVER_PORT} | awk 'NR==2 {print $2}') ]"
					continue
				fi

				# if [[ ${SERVER_PORT} -le 1023 ]]; then
				# 	_SUDO_PREFIX_EXEC="sudo"
				# fi

				break
			else
				PrintBlue "请输入一个从1024到65535的数字作为服务器端口号！"
			fi
		else
			PrintBlue "请输入数字！"
		fi
	done

	echo "--------------"
	while true; do
		echo "请输入分配给的服务器最小内存 | 正整数"
		read -p ">" MemoryJvmXms
		if [[ ${MemoryJvmXms} -gt 0 ]]; then
			break
		else
			PrintBlue "请输入一个正整数！"
		fi
	done

	echo "--------------"
	while true; do
		echo "请输入服务器最大分配内存 | 正整数"
		read -p ">" MemoryJvmXmx
		if [[ ${MemoryJvmXms} -gt 0 ]]; then
			if [[ ${MemoryJvmXms} -gt ${MemoryJvmXmx} ]]; then
				PrintBlue "你这分配的内存也太假了,小的数比大数都大 Σ(っ °Д °;)っ"
				continue
			fi
			break
		else
			PrintBlue "请输入一个正整数！"
		fi
	done

	echo "--------------"
	while true; do
		echo "请输入服务器世界名称 | 不要太奇怪就好 Qaq | 例如:world"
		read -p ">" LEVEL_NAME
		if ! checkStringNull "${LEVEL_NAME}"; then
			break
		else
			PrintBlue "认不出服务器目录就麻烦了..."
		fi
	done

	echo "--------------"
	while true; do
		echo "请输入服务器世界种子"
		read -p ">" WORLD_SEED
		if [[ $(echo ${WORLD_SEED} | wc -l) -gt 0 ]]; then
			#		if grep -E '[0-9a-zA-Z\+\-]' <<< "${WORLD_SEED}"; then
			break
		else
			PrintBlue "请输入!"
			#			PrintBlue "请输入一个整数！"
		fi
	done

	echo "--------------"
	while true; do
		echo "请输入服务器世界地图类型 | 普通-n | 超平坦-f | 大型生物群系-l"
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
		echo "是否在配置时生成奖励箱 |y / n|"
		read -p ">" BonusChestYoN
		if [[ ${BonusChestYoN} == 'y' ]]; then
			CONFIG_JAVA_OPTION="${CONFIG_JAVA_OPTION} -bonusChest"
			break
		fi
	done

	echo "--------------"
	while true; do
		echo "服务器默认游戏模式 | 生存-0 | 创造-1 | 冒险-2 | 旁观者-3 | 极限 - h"
		read -p ">" GAMDMODE
		if [[ ${GAMDMODE} == '0' ]] || [[ ${GAMDMODE} == '1' ]] || [[ ${GAMDMODE} == '2' ]] || [[ ${GAMDMODE} == '3' ]]; then
			break
		elif [[ ${GAMDMODE} == 'h' ]]; then
			HARDCORE_MODE_ENABLE="true"
			break
		else
			PrintBlue "请输入！"
		fi
	done

	echo "--------------"
	while true; do
		echo "是否在玩家进入游戏后强制改为服务器默认游戏模式 |y / n|"
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
		echo "开启Hardcore模式后,难度选项 -困难- 已不可改变!"
		DIFFICULTY_LEVEL=3
	else
		while true; do
			echo "服务器默认游戏难度 | 和平-0 | 简单-1 | 普通-2 | 困难-3"
			read -p ">" DIFFICULTY_LEVEL
			if [[ ${DIFFICULTY_LEVEL} == '0' ]] || [[ ${DIFFICULTY_LEVEL} == '1' ]] || [[ ${DIFFICULTY_LEVEL} == '2' ]] || [[ ${DIFFICULTY_LEVEL} == '3' ]]; then
				break
			fi
		done
	fi

	echo "--------------"
	while true; do
		echo "请输入最大在线玩家数量 | 正数数字 1-2147483647 >"
		read -p ">" MAX_PLAYERS
		if checkStringClassContains 0-9 ${MAX_PLAYERS}; then
			if [[ ${MAX_PLAYERS} -gt 0 ]]; then
				if [[ ${MAX_PLAYERS} -le 2147483647 ]]; then
					break
				else
					PrintBlue "超过范围啦..."
				fi
			else
				PrintBlue "不可为0或负数(把玩家都给ban了233)"
			fi
		fi
	done

	echo "--------------"
	while true; do
		echo "是否开启玩家PvP |y / n|"
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
		echo "是否允许玩家在服务器装有插件等的情况下飞行 |y / n|"
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
		echo "是否允许进入下界 |y / n|"
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
		echo "是否开启在线模式 |y / n|"
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
		echo "是否开启命令方块 |y / n|"
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
		echo "允许生成怪物 |y / n|"
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
		echo "请输入您希望服务器启动脚本的生成目录 | 例如：/root/"
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

	echo -n "导出配置 [server.properties]..."
	ServersettingCreate
	PrintGreen "完成"

	echo -n "创建启动脚本..."

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

	PrintGreen "完成"
	echo "已经在 ${ShFDir} 中创建启动脚本 [ start.sh ]"

	echo -n "生成配置脚本..."
	cat >Config.sh <<EOF
${JAVA_BINARY_PATH} -Xms${MemoryJvmXms}m -Xmx${MemoryJvmXmx}m -jar ./server.jar nogui
exit
EOF
	PrintGreen "完成"

	echo -n "开始配置..."
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
			echo "可能出现了一个错误" >/tmp/McServer/Config_Java_Run_Error
			ScriptExitF /tmp/McServer/Config_Java_Run_Error
		fi
		sleep 1
	done
	PrintGreen "完成"
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
	echo "Java版本定向到:${JAVA_INSTALL_VERSION}"
	echo "拉起JavaInstaller..."
	JavaInstaller
	JavaGetBinaryPath
	Configure
}

function JarStart {
	echo "检测Jar所需的Java版本..."
	checkPkgJavaVersion ./McServer/server.jar JAVA_INSTALL_VERSION 2>/tmp/McServer/check_JarVersion
	if [[ $? != 0 ]]; then
		echo "可能此文件不是Jar." >>/tmp/McServer/check_JarVersion
		ScriptExitF /tmp/McServer/check_JarVersion
	fi
	echo -n "Java选择版本..."
	PrintGreen ${JAVA_INSTALL_VERSION}

	JavaInstaller

	cd McServer

	echo "开始校验..."
	JarRunTest
	if [[ $? != 0 ]]; then
		ScriptExitF /tmp/McServer/Jar_Run_Test_Error
	fi
	if [[ -f "/tmp/McServer/Jar_Run_Test_Var.sh" ]]; then
		source /tmp/McServer/Jar_Run_Test_Var.sh
		echo "Java版本重定向到:${JAVA_INSTALL_VERSION}"
		echo "拉起JavaInstaller..."
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
		echo "在McServer已经有了一个服务器，请删除那些文件(不包括 server.jar) 或者 切换至其他目录继续安装"
		while true; do
			read -p "删除(d);退出(q) | " choose
			if [[ ${choose} = 'q' ]]; then
				ScriptClose Normal
			elif [[ ${choose} = 'd' ]]; then
				rm -rf $(ls McServer | grep -v "server.jar" | awk '{print "McServer/"$0}')
				break
			fi
		done
	fi

	echo "McServer目录中已存在 \"server.jar\" 文件"
	while true; do
		read -p "删除并继续(d);退出(q);继续安装这个 Jar 文件(c) | " choose

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
