## What is this?

  This is a small collection of tricks to automatically manage a Minecraft (Bedrock) server running on Linux with out the need of maintenance. 
  You can actually download, install, and run Minecraft Bedrock on your own server by downloading the file here https://www.minecraft.net/en-us/download/server/bedrock and following the bedrock_server_how_to.html file included. 
  
  (Mainly posting them on github so that I don't misplace them, but feel free to use/share/edit, if you do post it somewhere I don't mind if you share the link to this github)

## Where can I use these scripts? 

  Most recent Linux systems that use systemctl(systemd), Ubuntu, Red hat, Oracle Linux, Centos, etc.

## What exactly do they it do?


### 1. minecraft_service.sh 

  This script will create a service to manage (start/stop//status/restart) your Minecraft Server. It will also configure it to start on system boot/start. 

  You must edit the script file before executing it to add your linux user and Minecraft server installation directory in the lines below at the start of the file:
>user= 

>minedir= 

  Change the script permissions to 700 and excecute it as root:
> sudo chmod 700

> sudo ./minecraft_service.sh

  After running the script, you can view the service status with: 
> sudo systemctl status minecraft.service

### 2. update_bedrock_server.sh

  This script will stop your running Minecraft server via the service created with minecraft_service.sh.
  It will create a backup of your Minecraft installation folder. 
  Download the latest Bedrock server files for Linux from https://www.minecraft.net/en-us/download/server/bedrock and update (replace) your server files. 
  It will restore your server.properties, whitelist.json, permissions.json files as well as your worlds.
  And start up your Minecraft server again.

  You must also edit the script file and add your Minecraft server installation directory and your backup directory in the lines listed below at the start of the file:
>minedir=

>minebak=

  Change the script permissions to 700 and excecute it:
> sudo chmod 700

> ./update_bedrock_server.sh


#### Additional Tips: 

You can also create cronjobs to automatically run the update every day, week, month, etc.
This is not required but useful. You can also just run it manually when ever you need to. 
Here are a few examples: 

1. Edit your cronjobs: 
> crontab -e 

2. Choose one of the examples below to add into this file in a new line, save, and quit.  (Only add 1)


This one runs it daily and saves a log file to /tmp/minecraft-tmp/update_bedrock_server.log
> 0 0 * * * /home/alram/Update_Bedrock_Server.sh >> /tmp/minecraft-tmp/update_bedrock_server.log  2>&1

This one runs it every week:
> 0 0 * * 0 /home/alram/Update_Bedrock_Server.sh >> /tmp/minecraft-tmp/update_bedrock_server.log  2>&1

This one runs it on the 1st of every month:
> 0 0 1 * *  /home/alram/Update_Bedrock_Server.sh >> /tmp/minecraft-tmp/update_bedrock_server.log  2>&1

3. Check your configured cronjobs:
> crontab -l
