#!/usr/bin/bash

#Author:Maouai233(BiliBili)
#version:2.0
#Created Time:2021/08/10
#script Description:Install a server of Minecraft,there are more surprises in this script!Script may have bugs,but use should be no problem.
McServerChooseAndDownload(){

	echo "--------------------------------"
echo -e "1.17.1  1.17    1.16.5\n1.16.4  1.16.3  1.16.2\n1.16.1  1.15.2  1.15.1\n1.15    1.14.4  1.14.3\n1.14.2  1.14.1  1.14\n1.13.2  1.13.1  1.13\n1.12.2  1.12.1  1.12\n1.11.2  1.11.1  1.10.2\n1.10    1.9.4   1.9.2\n1.9     1.8.8   1.8.7\n1.8.6   1.8.5   1.8.4\n1.8.3   1.8     1.7.10\n1.7.9   1.7.8   1.7.5\n1.7.2   1.6.4   1.6.2\n1.5.2   1.5.1   1.4.7\n1.4.6\n Choose my Jar of Server(r)"
echo "--------------------------------"
read -p "Enter the version you want to install:" version
if [ "$version" = '1.17.1' ];then
	JAR="https://download.getbukkit.org/spigot/spigot-1.17.1.jar"
elif [ "$version" = '1.17' ];then
	JAR="https://download.getbukkit.org/spigot/spigot-1.17.jar"
elif [ "$version" = '1.16.5' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.16.5.jar"
elif [ "$version" = '1.16.4' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.16.4.jar"
elif [ "$version" = '1.16.3' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.16.3.jar"
elif [ "$version" = '1.16.2' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.16.2.jar"
elif [ "$version" = '1.16.1' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.16.1.jar"
elif [ "$version" = '1.15.2' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.15.2.jar"
elif [ "$version" = '1.15.1' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.15.1.jar"
elif [ "$version" = '1.15' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.15.jar"
elif [ "$version" = '1.14.4' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.14.4.jar"
elif [ "$version" = '1.14.3' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.14.3.jar"
elif [ "$version" = '1.14.2' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.14.2.jar"
elif [ "$version" = '1.14.1' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.14.1.jar"
elif [ "$version" = '1.14' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.14.jar"
elif [ "$version" = '1.13.2' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.13.2.jar"
elif [ "$version" = '1.13.1' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.13.1.jar"
elif [ "$version" = '1.13' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.13.jar"
elif [ "$version" = '1.12.2' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.12.2.jar"
elif [ "$version" = '1.12.1' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.12.1.jar"
elif [ "$version" = '1.12' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.12.jar"
elif [ "$version" = '1.11.2' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.11.2.jar"
elif [ "$version" = '1.11.1' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.11.1.jar"
elif [ "$version" = '1.11' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.11.jar"
elif [ "$version" = '1.10.2' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.10.2-R0.1-SNAPSHOT-latest.jar"
elif [ "$version" = '1.10' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.10-R0.1-SNAPSHOT-latest.jar"
elif [ "$version" = '1.9.4' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.9.4-R0.1-SNAPSHOT-latest.jar"
elif [ "$version" = '1.9.2' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.9.2-R0.1-SNAPSHOT-latest.jar"
elif [ "$version" = '1.9' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.9-R0.1-SNAPSHOT-latest.jar"
elif [ "$version" = '1.8.8' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.8.8-R0.1-SNAPSHOT-latest.jar"
elif [ "$version" = '1.8.7' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.8.7-R0.1-SNAPSHOT-latest.jar"
elif [ "$version" = '1.8.6' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.8.6-R0.1-SNAPSHOT-latest.jar"
elif [ "$version" = '1.8.5' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.8.5-R0.1-SNAPSHOT-latest.jar"
elif [ "$version" = '1.8.4' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.8.4-R0.1-SNAPSHOT-latest.jar"
elif [ "$version" = 1.8.3 ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.8.3-R0.1-SNAPSHOT-latest.jar"
elif [ "$version" = '1.8' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.8-R0.1-SNAPSHOT-latest.jar"
elif [ "$version" = '1.7.10' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.7.10-SNAPSHOT-b1657.jar"
elif [ "$version" = '1.7.9' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.7.9-R0.2-SNAPSHOT.jar"
elif [ "$version" = '1.7.8' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.7.8-R0.1-SNAPSHOT.jar"
elif [ "$version" = '1.7.5' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.7.5-R0.1-SNAPSHOT-1387.jar"
elif [ "$version" = '1.7.2' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.7.2-R0.4-SNAPSHOT-1339.jar"
elif [ "$version" = '1.6.4' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.6.4-R2.1-SNAPSHOT.jar"
elif [ "$version" = '1.6.2' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.6.2-R1.1-SNAPSHOT.jar"
elif [ "$version" = '1.5.2' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.5.2-R1.1-SNAPSHOT.jar"
elif [ "$version" = '1.5.1' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.5.1-R0.1-SNAPSHOT.jar"
elif [ "$version" = '1.4.7' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.4.7-R1.1-SNAPSHOT.jar"
elif [ "$version" = '1.4.6' ];then
	JAR="https://cdn.getbukkit.org/spigot/spigot-1.4.6-R0.4-SNAPSHOT.jar"
elif [ "$version" = 'r' ];then
	echo "Please put Jar in the MCSerVeR_2b41 directory"
	exit
fi
if ! [ -x "$(command -v wget)" ];then
	apt -y install wget
fi
if [ ! -n "$version" ];then
	echo "You did not enter any words!"
	exit
elif [ ! -n "$JAR" ];then
	echo "Invalid version number entered!"
	exit
else
	wget -O server.jar "$JAR" 
fi
}
#################################################################
Install() {
echo -n "Installing screeen..."
if ! [ -x "$(command -v screen)" ];then
    apt update
	apt-get -y install screen &>/dev/null
fi
echo "done"
echo -n "Configuring server..."
screen -dmS yoimiya
screen -r yoimiya -p 0 -X stuff "java -jar ./server.jar"
screen -r yoimiya -p 0 -X stuff "\n"
sleep 10
time=1
processMcSERVER=$(ps -fe|grep server.jar|grep java|grep -v grep|wc -l)
for ((;;))
do
	if [ "$processMcSERVER" = "1" ];then
		processMcSERVER=$(ps -fe|grep server.jar|grep java|grep -v grep|wc -l)
		echo -n "."
		time=$(expr $time + 1)
		if [ `expr $time + 0 ` -ge 18 ];then
			ScreenList=$(screen -ls|grep yoimiya|awk '{print $1}'|tr -d '.yoimiya')
			kill $ScreenList
			break
		fi
	else
		ScreenList=$(screen -ls|grep yoimiya|awk '{print $1}'|tr -d '.yoimiya')
			kill $ScreenList
		break
	fi
	sleep 1
done
echo "done"
echo -e "\n"
echo "--------------------------------"
echo "By changing the setting below to TRUE you are indicating your agreement to our EULA (https://account.mojang.com/documents/minecraft_eula)".
echo $(date +%F%n%T)
echo "--------------------------------"
echo "Just so you know, by downloading any of the software on this page, you agree to theMinecraft End User License AgreementandPrivacy Policy."
echo "--------------------------------"
if [ -f eula.txt ];then
	ServerEula
else 
	MojangServerEula
fi
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


clear
apt update
if ! [ -x "$(command -v java)" ];then
	apt-get -y install openjdk-11-jdk &>/dev/null
fi
apt-get -y install iptables

#	apt-get -y install default-jdk &>/dev/null
#
#	apt-get -y install openjdk-11-jre &>/dev/null
#
#	apt-get -y install openjdk-16-jdk &>/dev/null

PortOccupancy=$(lsof -i:25565|grep 25565|wc -l)
if [ `expr $PortOccupancy + 0` -eq 1 ];then
	echo "There is a process that takes up 25565 ports!"
	lsof -i:25565
	exit
fi
if ! [ -d "~/tmp-mcserver" ];then
	mkdir ~/tmp-mcserver
fi


if [ ! -d "MCSerVeR_2b41" ];then
	echo -n "Create a directory..."
	mkdir MCSerVeR_2b41
	echo "done"
else
	echo "Directory detected"
fi

cd MCSerVeR_2b41
if [ -f "server.jar" ];then
	echo "It is detected that there is already a "server.jar" file, please install it in another directory"
	read -p "delete(d);exit(e);Continue to install this Jar(c)|" choose
	if [ "$choose" = 'd' ];then
		rm -rf server.jar eula.txt server.properties logs
	elif [ "$choose" = 'e' ];then
		exit
	elif [ "$choose" = 'c' ];then
	Install
    ServerWorkingDirectory=$(pwd)
	fi
	else 
	echo "--------------------------------"
	McServerChooseAndDownload
	Install
	ServerWorkingDirectory=$(pwd)
fi

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
echo -n "Create startup script..."

echo "cd ${ServerWorkingDirectory}" &>> $ShFDir/start.sh
echo "iptables -I INPUT -p tcp --dport ${port} -j ACCEPT" &>> $ShFDir/start.sh
echo "screen -dmS MCSerVeR" &>> $ShFDir/start.sh
echo -e "screen -r MCSerVeR -p 0 -X stuff \"java -Xms1024m -Xmx1024m -jar server.jar\"" &>> $ShFDir/start.sh
echo "screen -r MCSerVeR -p 0 -X stuff '\n'" &>> $ShFDir/start.sh
sleep 1
cp $ShFDir/start.sh ~/tmp-mcserver/
echo "done"
echo "The startup script has been created in "$ShFDir
bash $ShFDir/start.sh
sleep 15
processMcSERVER_2=$(ps -fe|grep server.jar|grep java|grep -v grep|wc -l)
for ((;;))
do
	if [ "$processMcSERVER_2" = "1" ];then
		processMcSERVER_2=$(ps -fe|grep server.jar|grep java|grep -v grep|wc -l)
		screen -r MCSerVeR -p 0 -X stuff "stop" 
        screen -r MCSerVeR -p 0 -X stuff "\n"
		echo -n "."
	else
		ScreenList=$(screen -ls|grep MCSerVeR|awk '{print $1}'|tr -d '.MCSerVeR')
		kill $ScreenList
		break
	fi
	sleep 1
done
cd $ServerWorkingDirectory
sed -i "s/25565/$port/" server.properties
echo -e "\n"
echo "=============Ok=============" 
echo -e "\n"