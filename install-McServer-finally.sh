#!/usr/bin/env bash

#Author:Maouai233
#version:2.1-Rebuild-20220514
#Created Time:2022/05/14
#script Description:Install a server of Minecraft,there are more surprises in this script!Script may have some bugs,but to use is no problem.

ScriptInit(){
	PortOccupancy=$(lsof -i:25565|grep 25565|wc -l)
	if [ `expr $PortOccupancy + 0` -eq 1 ];then
		echo "There is a process that takes up 25565 ports!"
		lsof -i:25565
		exit 1
	fi

	if [[ ! -d ~/tmp-mcserver ]];then
		mkdir ~/tmp-mcserver
	fi


	if [[ ! -d "MCSerVeR_2b41" ]];then
		echo -n "Create the Server directory..."
		mkdir MCSerVeR_2b41
		echo "done"
	else
		echo "Directory detected"
	fi
}

ScriptClose(){
	rm -rf ~/tmp-mcserver
}

SoftwareInstall()
{
	echo -n "Update software list..."
#	apt update &> /dev/null
	echo "done"

	if [[ -x `command wget --version` ]];then
		echo -n "Installing Wget..."
		apt -y install wget >/dev/null
		echo "done"
	else
		echo "Wget has already Installed"
	fi

	if [[ -x `command java --version` ]];then
		read -p  "It will make your computer Install OpenJDK-17,Type any keys to Continue" tmp
		echo -n "Installing Java..."
		apt-get -y install openjdk-17-jdk > /dev/null
		apt-get -y install openjdk-17-jre > /dev/null
		echo "done"
	else 
		echo "Java has already Installed"
	fi

	if [[ -x `command iptables --version` ]];then
		echo -n "Installing Iptables..."
		apt-get -y install iptables > /dev/null
		echo "done"
	else
		echo "Iptables has already Installed"
	fi

	if [[ -x `command screen --version` ]];then
		echo -n "Installing Screen..."
		apt-get -y install screen >/dev/null
		echo "done"
	else
		echo "Screen has already Installed"
	fi
}

McServerChooseAndDownload(){
    for ((;;))
    do
	echo "--------------------------------"
	echo -e "1.18.2  1.18.1  1.18 \n1.17.1  1.17    1.16.5\n1.16.4  1.16.3  1.16.2\n1.16.1  1.15.2  1.15.1\n1.15    1.14.4  1.14.3\n1.14.2  1.14.1  1.14\n1.13.2  1.13.1  1.13\n1.12.2  1.12.1  1.12\n1.11.2  1.11.1  1.10.2\n1.10    1.9.4   1.9.2\n1.9     1.8.8   1.8.7\n1.8.6   1.8.5   1.8.4\n1.8.3   1.8     1.7.10\n1.7.9   1.7.8   1.7.5\n1.7.2   1.6.4   1.6.2\n1.5.2   1.5.1   1.4.7\n1.4.6\n Choose my Jar of Server(r)"
	echo "--------------------------------"
	read -p "Enter the version you want to install:" version
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
	elif [[ "$version" = 1.8.3 ]];then
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
			echo "Please put Jar in the MCSerVeR_2b41 directory.Rename it to \"server.jar\""
			exit 0
		fi
	fi

	if ! [ -x "$(command -v wget)" ];then
		apt -y install wget
	fi

	if [[ ! -n "$version" ]];then
		echo "You did not enter any words!"
	elif [[ ! -n "$JAR" ]];then
		echo "Invalid version number entered!"
	else
		wget -O server.jar "$JAR"
		break 
	fi

	done

}

#################################################################

Install() {
	echo -n "Creating the Configuring Script..."
	
	echo "java -jar ./server.jar" > config.sh
	echo "exit" >> config.sh
	
	echo "done"
	echo -n "Configuring server..."
	screen -dmS ConfigTerm bash ./config.sh
	for ((i=0;i<20;i=i+1))
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

	echo "done"
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
		read -p "Angree(yes)|" eulaAngreeYoN
		if [ "$eulaAngreeYoN" = "yes" ];then
			sed -i 's/false/true/' eula.txt
			break
		else
			echo -e "Please enter \"yes\" /\033[31m ^C \033[0m"
		fi
	done
	echo "This is 1.7.10+"

}

MojangServerEula(){
	for ((;;))
	do
		read -p "Angree(yes)|" eulaAngreeYoN
		if [ "$eulaAngreeYoN" = "yes" ];then
			break
		else
			echo -e "Please enter \"yes\" /\033[31m ^C \033[0m"
		fi
	done
	echo "This is 1.7.10-"
}

#################################################################

Configure(){
	#apt update

	#	apt-get -y install openjdk-11-jdk &>/dev/null
	#
	#	apt-get -y install openjdk-16-jdk &>/dev/null

	echo -n "Change Owner..."
	chown -v -R ./*
	echo "done"

	for ((;;))
	do
		read -p "Please enter the Server port number|" portNumber
		if grep '^[[:digit:]]*$' <<< "$portNumber"; then
			if [ `expr $portNumber + 0` -le 65535 ];then
				if [ `expr $portNumber + 0` -gt 1024 ];then
					port=$portNumber
					break
				else
					echo "Please enter a number from 1024 to 65535"
				fi
			else
				echo "Please enter a number from 1024 to 65535"
			fi
		else 
			echo "Please enter the number!"
		fi	
	done

	read -p "Please enter the generated startup script directory|For example: /root/ |" ShFDir
	if ! [ -d $ShFDir ];then
		mkdir $ShFDir
	fi
	echo -n "Creating startup script..."

	echo "cd ${ServerWorkingDirectory}" > $ShFDir/start.sh
	echo "iptables -I INPUT -p tcp --dport ${port} -j ACCEPT > /dev/null" >> $ShFDir/start.sh
	echo -e "screen java -Xms1024m -Xmx1024m -jar ./server.jar" >> $ShFDir/start.sh

	cp $ShFDir/start.sh ~/tmp-mcserver/
	echo "done"
	echo "The startup script has been created in "$ShFDir
	if ! [[ `expr $NeverConfigAgain + 0` -eq 1 ]];then
		screen -dmS ConfigScreen bash config.sh
		echo -n "Configuring server..."
		processMcSERVER_2=$(ps -fe|grep server.jar|grep java|grep -v grep|wc -l)
		for ((;;))
		do
			echo -n "."
			if [[ `cat logs/latest.log|grep help|grep ?|grep INFO|wc -l` -gt 0 ]];then
				kill -9 `ps -fe|grep server.jar|grep java|grep -v grep|awk '{print $2}'` &> /dev/null
				break
			fi

			if [[ `ps -fe|grep server.jar|grep java|grep -v grep|wc -l` -eq 0 ]];then
				echo "That maybe an Error"
				exit 1
			fi
			sleep 1
		done
	fi
	cd $ServerWorkingDirectory
	sed -i "s/25565/$port/" server.properties
	echo -e "\n"
	echo "-----------DONE-----------" 
	echo -e "\n"

}

ScriptInit
SoftwareInstall
echo $USER
if [ -f "MCSerVeR_2b41/server.jar" ];then
	if [[ -d "MCSerVeR_2b41/world" || -d "MCSerVeR_2b41/logs" ]];then
		echo "There is a Server in the Directory,please REMOVE that(except server.jar) or CHANGE directories"
		for ((;;))
		do
			read -p  "delete(d);exit(e)|" choose
			if [[ $choose = "e" ]];then
				exit 0
			elif [[ $choose = "d" ]];then
				rm -rf `ls MCSerVeR_2b41/|grep -v "server.jar"|awk '{print "MCSerVeR_2b41/"$0}'`
				break
			fi
		done
	fi

	echo "It is detected that there is already a \"server.jar\" file, please install it in another directory"
	for ((;;))
	do
		read -p "delete(d);exit(e);Continue to install this Jar(c)|" choose
	
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
			ServerWorkingDirectory=$(pwd)
			Install
			break
		fi
	done
else 
	echo "--------------------------------"
	cd MCSerVeR_2b41
	ServerWorkingDirectory=$(pwd)
	McServerChooseAndDownload
	Install
fi

echo "If you can not connect to your Server or Iptables can't use,please use \"apt remove iptables\"to remove iptables.And your Machine must Open the port of MC Server."
echo -e "\n"
echo "If there are some bugs,please send to me.\nMy email:Maouai233@outlook.com"

ScriptClose
