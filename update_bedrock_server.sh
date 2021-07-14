#!/bin/bash
#This script was created to automatically download the latest Bedrock Minecraft server files, backup, update, and restore configurations on Linux.
#Files are downloaded from https://www.minecraft.net/en-us/download/server/bedrock. 
#It's not the most professional/clean one but it gets the job done. I was just lazy to manually update the files so this was created. 
#Also verbosed it a bit to make sure everything worked as expected. 
#More random stuff can be found at https://github.com/pecrow/minecraft-scripts .I wouldn't mind if you link this in case you post it some where.
#This also requires that you configure your minecraft.service, steps can be found on github link above.

#This is your current Minecraft installation directory. Replace this one with your install directory/folder. 
minedir=/home/alram/MinecraftServer_Bedrock

#This is where you want to save a backup of your Minecraft server files and worlds.
minebak=/home/alram/MinecraftServer_Backup

#Temp directory for file downloads; will be cleared at the end.
minetmp=/tmp/minecraft-tmp

echo "----------------Start----------------"
echo "Starting minecraft bedrock server update on $(date)"
echo "Stopping Minecraft.Service"
sudo systemctl stop minecraft.service
echo "Creating backup directory at $minebak and temp directory at $minetmp"
mkdir -vp $minebak $minetmp 2>/dev/null
echo "Backing up all configuration files and worlds to $minebak"
#This will copy everything excluding hidden files.
rsync -av --exclude='.*' $minedir/* $minebak/
echo "Downloading latest bedrock server files from https://www.minecraft.net/en-us/download/server/bedrock"
#This one was fun to think about. I'm sure I could of filetered everything w/ awk, just lazy to look it up. Don't judge me.
curl "https://www.minecraft.net/en-us/download/server/bedrock" -H "Accept-Encoding: gzip,deflate,sdch" -H "Accept-Language: en-US,en;q=0.8" -H "User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.143 Safari/537.36" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" -H "Referer: http://google.com"-H "Connection: keep-alive" -H "Cache-Control: max-age=0" --compressed -P $minetmp/bedrock ; wget  $(cat $minetmp/bedrock | grep bin-linux | awk '{print $2}' |sed 's/href=//' | tr -d '"') -P $minetmp/
echo "Now unzipping file $(cat $minetmp/bedrock | grep bin-linux | awk '{print $2}' |sed 's/href=//' | tr -d '"' |awk -F / '{print $NF}') "
unzip -o $minetmp/$(cat $minetmp/bedrock | grep bin-linux | awk '{print $2}' |sed 's/href=//' | tr -d '"' |awk -F / '{print $NF}')  -d $minedir
echo "Cleaning  $minetmp"
rm -Rv $minetmp/bedrock*
echo "Restoring server.properties, whitelist.json, and permissions.json"
#This is just restoring basic files I needed, you can add more here if you want.
cp -v $minebak/server.properties $minedir
cp -v $minebak/whitelist.json $minedir
cp -v $minebak/permissions.json $minedir
echo "Restoring worlds"
cp -v -R $minebak/worlds $minedir
echo "Now starting minecraft.service"
sudo systemctl daemon-reload && sudo systemctl start minecraft.service
echo "Update completed at $(date)"
echo "------------------End------------------"
