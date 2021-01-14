#!/bin/bash
#This script will create your Minecraft service and enable it.
#More random stuff can be found at https://github.com/pecrow/minecraft-scripts .I wouldn't mind if you link this in case you post it some where.

#NOTE: You MUST replace <user> with the linux user that will run the Minecraft server and <minedir> with your Minecraft server file install directory.
user=alram
minedir=/home/alram/MinecraftServer_Bedrock


echo "Creating service for the user $user and the Minecraft server files located under $minedir"
sudo cat >> /etc/systemd/system/minecraft.service << EOF
[Unit]
Description=Minecraft Bedrock Service
After=network-online.target

[Service]
User=$user
WorkingDirectory=$minedir
Type=forking
ExecStart=/usr/bin/screen -dmS Minecraft /bin/bash -c "LD_LIBRARY_PATH=. ./bedrock_server"
ExecStop=/usr/bin/screen -Rd Minecraft -X stuff "say Stopping server in 10 seconds...\r"
ExecStop=/bin/sleep 10
ExecStop=/usr/bin/screen -Rd Minecraft -X stuff "stop\r"
GuessMainPID=no
TimeoutStartSec=600

[Install]
WantedBy=multi-user.target
EOF
echo "Changing file permissions and enabling the service."
sudo chmod 755 /etc/systemd/system/minecraft.service
sudo systemctl enable minecraft.service
sudo systemctl daemon-reload
