function Init {
	echo "初始化脚本..."
	for ((idx = 0; idx < 7; idx++)); do
		export CH_PRINT_${idx}="PrintGreen"
	done
	echo "进入服务器目录..."
	cd ${SERVER_WORKING_DIR}
}

function Status {
	screen -ls | grep "McServerTerm" >/dev/null 2>&1
	return $?
}

function Start {
	if ! [[ $(screen -ls | grep "McServerTerm" | wc -l) -gt 0 ]]; then
		echo -n "开始启动服务器..."
		rm -rf logs/latest.log 2>/dev/null
		screen -dmS McServerTerm ${JAVA_BINARY_PATH} -Xms${MemoryJvmXms}m -Xmx${MemoryJvmXmx}m -jar ./server.jar nogui
		while ! cat logs/latest.log 2>/dev/null | grep INFO | grep Done | grep help >/dev/null 2>&1; do
			echo -n "."
			sleep 1
		done
	else
		echo "服务器正在运行."
	fi
}

function Connect {
	screen -x -S McServerTerm
}

function Stop {
	while ps aux | grep -v "grep" | grep "java" | grep "server.jar" >/dev/null 2>&1; do
		screen -x -S McServerTerm -p 0 -X stuff "stop\n"
		sleep 1
	done
}

function Restart {
	if ! ps aux | grep -v "grep" | grep "java" | grep "server.jar" >/dev/null 2>&1; then
		return 1
	fi
	Stop
	Start
}

function ReloadConfig {
	screen -x -S McServerTerm -p 0 -X stuff "reload\n"
}

function Kill {
	while ps aux | grep -v "grep" | grep "java" | grep "server.jar" >/dev/null 2>&1; do
		PROCESS_NUM=$(ps aux | grep -v "grep" | grep "java" | grep "server.jar" | awk '{print $2}')
		kill -9 ${PROCESS_NUM} 2>/dev/null
	done

	screen -wipe >/dev/null 2>&1
	sleep 1
}

_EXEC_HOME_=$(pwd)

Init

while true; do
	if Status; then # The Server is Running
		CH_PRINT_0="PrintRed"
		#		export {CH_PRINT_1,CH_PRINT_2,CH_PRINT_3,CH_PRINT_4,CH_PRINT_5}="PrintGreen"
		CH_PRINT_1="PrintGreen"
		CH_PRINT_2="PrintGreen"
		CH_PRINT_3="PrintGreen"
		CH_PRINT_4="PrintGreen"
		CH_PRINT_5="PrintGreen"
	else
		CH_PRINT_0="PrintGreen"
		CH_PRINT_1="PrintRed"
		CH_PRINT_2="PrintRed"
		CH_PRINT_3="PrintRed"
		CH_PRINT_4="PrintRed"
		CH_PRINT_5="PrintRed"
	fi
	echo "------------"
	screen -ls | awk '{NR==2;print $0}'
	echo "------------"
	$CH_PRINT_0 "0. 启动"
	$CH_PRINT_1 "1. 打开服务器控制台 - McServerTerm"
	$CH_PRINT_2 "2. 保存并退出服务器"
	$CH_PRINT_3 "3. 重启服务器"
	$CH_PRINT_4 "4. 重载服务器配置文件 - server.properties"
	$CH_PRINT_5 "5. 强制停止(不建议,有风险),使用 SIGNAL-9"
	$CH_PRINT_6 "6. Quit"
	echo "------------"

	read -p "CHOOSE | " CHOOSE

	case ${CHOOSE} in
	0)
		if [[ ${CH_PRINT_0} == "PrintGreen" ]]; then
			Start
		else
			echo "服务器已经运行啦."
		fi
		;;
	1)
		if [[ ${CH_PRINT_1} == "PrintGreen" ]]; then
			Connect
		else
			echo "无法连接,服务器可能没有运行."
		fi
		;;
	2)
		if [[ ${CH_PRINT_2} == "PrintGreen" ]]; then
			Stop
		else
			echo "无法停止,服务器可能没有运行."
		fi
		;;
	3)
		if [[ ${CH_PRINT_2} == "PrintGreen" ]]; then
			Restart
		else
			echo "无法重启服务器,服务器可能没有运行."
		fi
		;;
	4)
		if [[ ${CH_PRINT_2} == "PrintGreen" ]]; then
			ReloadConfig
		else
			echo "无法重载配置,服务器可能没有运行."
		fi
		;;
	5)
		if [[ ${CH_PRINT_2} == "PrintGreen" ]]; then
			Kill
		else
			echo "无法强制停止服务器,服务器可能没有运行."
		fi
		;;
	6 | 'q' | "quit" | "exit")
		exit 0
		;;
	"clear")
		clear
		;;

	esac
done
