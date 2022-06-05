cd /media/maouai233/tmp/install_minecraft_server/MCSerVeR_2b41
iptables -I INPUT -p tcp --dport 25565 -j ACCEPT 2> /dev/null
screen java -Xms512m -Xmx512m -jar ./server.jar
