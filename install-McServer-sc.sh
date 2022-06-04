#!/usr/bin/env bash

#Author:Maouai233
#version:2.2-build-20220604
#Created Time:2022/06/04
#script Description:Install a server of Minecraft,there are more surprises in this script!Script may have some bugs,but to use is no problem.

ScriptInit() {
	PortOccupancy=$(lsof -i:25565|grep 25565|wc -l)
	if [ `expr $PortOccupancy + 0` -eq 1 ];then
		echo "25565端口以被其他进程占用！"
		lsof -i:25565
		exit 1
	fi

	if [[ ! -d ~/tmp-mcserver ]];then
		mkdir ~/tmp-mcserver
	fi


	if [[ ! -d "MCSerVeR_2b41" ]];then
		echo -n "创建服务器目录..."
		mkdir MCSerVeR_2b41
		echo "完成"
	else
		echo "目录已存在"
	fi

	Status=0
}

ScriptClose(){
	rm -rf ~/tmp-mcserver
}

SoftwareInstall()
{
	echo -n "更新软件列表..."
#	apt update &> /dev/null
	echo "完成"

	if [[ -x `command wget --version` ]];then
		echo -n "安装 Wget..."
		apt -y install wget >/dev/null
		echo "完成"
	else
		echo "Wget 已安装"
	fi

	if ! command -v java;then
		read -p  "将会安装Openjdk-17，键入任意键继续" tmp
		echo -n "安装 Java..."
		apt-get -y install openjdk-17-jdk > /dev/null
		apt-get -y install openjdk-17-jre > /dev/null
		echo "完成"
	else 
		echo "Java 已安装"
	fi

	if [[ -x `command iptables --version` ]];then
		echo -n "安装 Iptables..."
		apt-get -y install iptables > /dev/null
		echo "完成"
	else
		echo "Iptables 已安装"
	fi

	if [[ -x `command screen --version` ]];then
		echo -n "安装 Screen..."
		apt-get -y install screen >/dev/null
		echo "完成"
	else
		echo "Screen 已安装"
	fi
}

McServerChooseAndDownload(){
    for ((;;))
    do
	echo "--------------------------------"
	echo -e "1.18.2  1.18.1  1.18 \n1.17.1  1.17    1.16.5\n1.16.4  1.16.3  1.16.2\n1.16.1  1.15.2  1.15.1\n1.15    1.14.4  1.14.3\n1.14.2  1.14.1  1.14\n1.13.2  1.13.1  1.13\n1.12.2  1.12.1  1.12\n1.11.2  1.11.1  1.10.2\n1.10    1.9.4   1.9.2\n1.9     1.8.8   1.8.7\n1.8.6   1.8.5   1.8.4\n1.8.3   1.8     1.7.10\n1.7.9   1.7.8   1.7.5\n1.7.2   1.6.4   1.6.2\n1.5.2   1.5.1   1.4.7\n1.4.6\n 选择本地的Jar安装(r)"
	echo "--------------------------------"
	read -p "键入您想要安装的服务器版本:" version
	if [[ "$version" = '1.18.2' ]];then
		JAR="https://download.getbukkit.org/spigot/spigot-1.18.2.jar"
	elif [[ "$version" = '1.18.1' ]];then
		JAR="https://download.getbukkit.org/spigot/spigot-1.18.1.jar"
	elif [[ "$version" = '1.18' ]];then
		JAR="https://download.getbukkit.org/spigot/spigot-1.18.jar"
	elif [[ "$version" = '1.17.1' ]];then
		JAR="https://download.getbukkit.org/spigot/spigot-1.17.1.jar"
	elif [[ "$version" = '1.17' ]];then
		JAR="https://download.getbukkit.org/spigot/spigot-1.17.jar"
	elif [[ "$version" = '1.16.5' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.16.5.jar"
	elif [[ "$version" = '1.16.4' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.16.4.jar"
	elif [[ "$version" = '1.16.3' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.16.3.jar"
	elif [[ "$version" = '1.16.2' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.16.2.jar"
	elif [[ "$version" = '1.16.1' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.16.1.jar"
	elif [[ "$version" = '1.15.2' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.15.2.jar"
	elif [[ "$version" = '1.15.1' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.15.1.jar"
	elif [[ "$version" = '1.15' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.15.jar"
	elif [[ "$version" = '1.14.4' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.14.4.jar"
	elif [[ "$version" = '1.14.3' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.14.3.jar"
	elif [[ "$version" = '1.14.2' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.14.2.jar"
	elif [[ "$version" = '1.14.1' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.14.1.jar"
	elif [[ "$version" = '1.14' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.14.jar"
	elif [[ "$version" = '1.13.2' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.13.2.jar"
	elif [[ "$version" = '1.13.1' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.13.1.jar"
	elif [[ "$version" = '1.13' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.13.jar"
	elif [[ "$version" = '1.12.2' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.12.2.jar"
	elif [[ "$version" = '1.12.1' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.12.1.jar"
	elif [[ "$version" = '1.12' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.12.jar"
	elif [[ "$version" = '1.11.2' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.11.2.jar"
	elif [[ "$version" = '1.11.1' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.11.1.jar"
	elif [[ "$version" = '1.11' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.11.jar"
	elif [[ "$version" = '1.10.2' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.10.2-R0.1-SNAPSHOT-latest.jar"
	elif [[ "$version" = '1.10' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.10-R0.1-SNAPSHOT-latest.jar"
	elif [[ "$version" = '1.9.4' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.9.4-R0.1-SNAPSHOT-latest.jar"
	elif [[ "$version" = '1.9.2' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.9.2-R0.1-SNAPSHOT-latest.jar"
	elif [[ "$version" = '1.9' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.9-R0.1-SNAPSHOT-latest.jar"
	elif [[ "$version" = '1.8.8' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.8.8-R0.1-SNAPSHOT-latest.jar"
	elif [[ "$version" = '1.8.7' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.8.7-R0.1-SNAPSHOT-latest.jar"
	elif [[ "$version" = '1.8.6' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.8.6-R0.1-SNAPSHOT-latest.jar"
	elif [[ "$version" = '1.8.5' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.8.5-R0.1-SNAPSHOT-latest.jar"
	elif [[ "$version" = '1.8.4' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.8.4-R0.1-SNAPSHOT-latest.jar"
	elif [[ "$version" = '1.8.3' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.8.3-R0.1-SNAPSHOT-latest.jar"
	elif [[ "$version" = '1.8' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.8-R0.1-SNAPSHOT-latest.jar"
	elif [[ "$version" = '1.7.10' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.7.10-SNAPSHOT-b1657.jar"
	elif [[ "$version" = '1.7.9' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.7.9-R0.2-SNAPSHOT.jar"
	elif [[ "$version" = '1.7.8' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.7.8-R0.1-SNAPSHOT.jar"
	elif [[ "$version" = '1.7.5' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.7.5-R0.1-SNAPSHOT-1387.jar"
	elif [[ "$version" = '1.7.2' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.7.2-R0.4-SNAPSHOT-1339.jar"
	elif [[ "$version" = '1.6.4' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.6.4-R2.1-SNAPSHOT.jar"
	elif [[ "$version" = '1.6.2' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.6.2-R1.1-SNAPSHOT.jar"
	elif [[ "$version" = '1.5.2' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.5.2-R1.1-SNAPSHOT.jar"
	elif [[ "$version" = '1.5.1' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.5.1-R0.1-SNAPSHOT.jar"
	elif [[ "$version" = '1.4.7' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.4.7-R1.1-SNAPSHOT.jar"
	elif [[ "$version" = '1.4.6' ]];then
		JAR="https://cdn.getbukkit.org/spigot/spigot-1.4.6-R0.4-SNAPSHOT.jar"
	elif [[ "$version" = 'r' ]];then
		if ! [[ -f MCSerVeR_2b41/server.jar ]];then
			echo "请把Jar文件移入MCSerVeR_2b41目录，并重命名它为 \"server.jar\"。"
			exit 0
		fi
	fi

	if ! [ -x "$(command -v wget)" ];then
		apt -y install wget
	fi

	if [[ ! -n "$version" ]];then
		echo "您没有输入任何版本号！"
	elif [[ ! -n "$JAR" ]];then
		echo "输入的版本号无效！"
	else
		wget -O server.jar "$JAR"
		break 
	fi

	done

}

#################################################################

Install() {
	echo -n "创建服务器配置脚本..."
	
	echo "java -jar ./server.jar" > config.sh
	echo "exit" >> config.sh
	
	echo "完成"
	echo -n "配置服务器..."
	screen -dmS ConfigTerm bash ./config.sh
	for ((i=0;$i<20;i=`expr $i + 1`))
	do
		echo -n "."
		sleep 1
	done

	if ! [[ -d "logs" ]];then
		for ((;;))
		do
			echo -n "."
			if [[ $(cat `ls|grep -v server.jar|grep -v server.pro|grep log` |grep help|grep "?"|grep INFO|wc -l) -gt 0 ]];then
	        		NeverConfigAgain=1
				processMcSERVER=$(ps -fe|grep server.jar|grep java|grep -v grep|wc -l)
	       			if [[ $processMcSERVER -gt 0 ]];then
					processNum=$(ps -fe|grep server.jar|grep java|grep -v grep|awk '{print $2}')
					kill -9 $processNum > /dev/null
					break
				fi
			fi

			sleep 1
		done
	else
		for ((;;))
		do
			echo -n "."
			if [[ `cat logs/latest.log|grep agree|grep "eula.txt"|wc -l` -gt 0 ]];then
				break
			fi
			sleep 1
		done
	fi

	echo "完成"
	echo -e "\n"
	echo "--------------------------------"
	echo "By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula)".
	echo $(date +%F%n%T)
	echo "--------------------------------"
	echo "Just so you know, by downloading any of the software on this page, you agree to theMinecraft End User License AgreementandPrivacy Policy."
	echo "--------------------------------"
	if [ -f "eula.txt" ];then
		ServerEula
	else 
		MojangServerEula
	fi
	Configure
}

ServerEula() {
	for ((;;))
	do
		read -p "同意(yes)|" eulaAngreeYoN
		if [ "$eulaAngreeYoN" = "yes" ];then
			sed -i 's/false/true/' eula.txt
			break
		else
			echo -e "请输入 \"yes\" /\033[31m ^C \033[0m"
		fi
	done
	echo "这是 1.7.10 及以上的版本"

}

MojangServerEula(){
	for ((;;))
	do
		read -p "同意(yes)|" eulaAngreeYoN
		if [ "$eulaAngreeYoN" = "yes" ];then
			break
		else
			echo -e "请输入 \"yes\" /\033[31m ^C \033[0m"
		fi
	done
	echo "这是 1.7.10 以下的版本"
}

#################################################################

Configure(){
	#apt update

	#	apt-get -y install openjdk-11-jdk &>/dev/null
	#
	#	apt-get -y install openjdk-16-jdk &>/dev/null

#	echo -n "Change Owner..."
#	chown -v -R ./*
#	echo "done"

	for ((;;))
	do
		read -p "请输入服务器端口号|" portNumber
		if grep '^[[:digit:]]*$' <<< "$portNumber"; then
			if [ `expr $portNumber + 0` -le 65535 ];then
				if [ `expr $portNumber + 0` -gt 1024 ];then
					port=$portNumber
					break
				else
					echo "请输入一个从1024到65535的数字作为服务器端口号！"
				fi
			else
				echo "请输入一个从1024到65535的数字作为服务器端口号！"
			fi
		else 
			echo "请输入数字！"
		fi
	done
	
	for ((;;))
	do
		read -p "请输入服务器最小内存 |" MemoryJvmXms
		if grep '^[[:digit:]]*$' <<< "$MemoryJvmXms"; then
			if [ `expr $MemoryJvmXms + 0` -gt 0 ];then
				break
			else
				echo "请输入一个正整数！"
			fi
		else
			echo "请输入数字！"
		fi	
	done
	
	for ((;;))
	do
		read -p "请输入服务器最大分配内存 |" MemoryJvmXmx
		if grep '^[[:digit:]]*$' <<< "$MemoryJvmXmx"; then
			if [ `expr $MemoryJvmXmx + 0` -ge "$MemoryJvmXms" ];then
				break
			else
				echo "请输入一个大于最小内存的正整数！"
			fi
		else
			echo "请输入数字！"
		fi
	done

	read -p "请输入您希望服务器启动脚本的生成目录 | 例如：/root/ |" ShFDir
	if ! [ -d $ShFDir ];then
		mkdir $ShFDir
	fi
	echo -n "创建启动脚本..."

	echo "cd ${ServerWorkingDirectory}" > $ShFDir/start.sh
	echo "iptables -I INPUT -p tcp --dport ${port} -j ACCEPT > /dev/null" >> $ShFDir/start.sh
	echo -e "screen java -Xms${MemoryJvmXms}m -Xmx${MemoryJvmXmx}m -jar ./server.jar" >> $ShFDir/start.sh

	cp $ShFDir/start.sh ~/tmp-mcserver/
	echo "完成"
	echo "已经在 $ShFDir 中创建脚本"
	if ! [[ `expr $NeverConfigAgain + 0` -eq 1 ]];then
		screen -dmS ConfigScreen bash config.sh
		echo -n "配置服务器..."
		processMcSERVER_2=$(ps -fe|grep server.jar|grep java|grep -v grep|wc -l)
		for ((;;))
		do
			echo -n "."
			if [[ `cat logs/latest.log|grep help|grep ?|grep INFO|wc -l` -gt 0 ]];then
				kill -9 `ps -fe|grep server.jar|grep java|grep -v grep|awk '{print $2}'` &> /dev/null
				break
			fi

			if [[ `ps -fe|grep server.jar|grep java|grep -v grep|wc -l` -eq 0 ]];then
				echo "可能出现了一个错误"
				exit 1
			fi
			sleep 1
		done
	fi
	cd $ServerWorkingDirectory
	sed -i "s/25565/$port/" server.properties
	echo -e "\n"
	echo "-----------完成-----------" 
	echo -e "\n"

}

ScriptInit
SoftwareInstall
echo $USER
if [ -f "MCSerVeR_2b41/server.jar" ];then
	if [[ -d "MCSerVeR_2b41/world" || -d "MCSerVeR_2b41/logs" ]];then
		echo "在MCSerVeR_2b41已经有了一个服务器，请删除那些文件(不包括 server.jar) 或者 切换其他目录继续安装"
		for ((;;))
		do
			read -p  "删除(d);退出(e)|" choose
			if [[ $choose = "e" ]];then
				exit 0
			elif [[ $choose = "d" ]];then
				rm -rf `ls MCSerVeR_2b41/|grep -v "server.jar"|awk '{print "MCSerVeR_2b41/"$0}'`
				break
			fi
		done
	fi

	echo "MCSerVeR_2b41目录中已存在 \"server.jar\" 文件"
	for ((;;))
	do
		read -p "删除(d);退出(e);继续安装这个 Jar 文件(c)|" choose
	
		if [ "$choose" = 'd' ];then
			rm -rf MCSerVeR_2b41/*
			cd MCSerVeR_2b41
			ServerWorkingDirectory=$(pwd)
			McServerChooseAndDownload
			Install
			break
		elif [ "$choose" = 'e' ];then
			exit 0
		elif [ "$choose" = 'c' ];then
			cd MCSerVeR_2b41
			Return=`java -jar server.jar 2>&1`
			if [[ `echo $Return|grep "Error"|wc -l` -gt 0 ]];then
				echo -e "Java返回 ：$Return\n"
				Status=1
				break
			else
				ServerWorkingDirectory=$(pwd)
				Install
				break
			fi
		fi
	done
else 
	echo "--------------------------------"
	cd MCSerVeR_2b41
	ServerWorkingDirectory=$(pwd)
	McServerChooseAndDownload
	Install
fi

echo "如果您不能连接到您搭建的服务器 或者 iptables无法使用,请使用 \"apt remove iptables\" 卸载iptables以暴力解决QwQ。并且您的服务器必须开启MC服务器所用端口。"
echo -e "\n"
echo -e "如果有Bug，您可以发邮件给我\n我的邮箱:Maouai233@outlook.com"

exit $Status

ScriptClose
