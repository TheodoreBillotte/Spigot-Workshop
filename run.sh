#!/bin/bash

# install JDK 19 if not already installed
if [ ! -d "/usr/lib/jvm/java-19-openjdk-amd64" ]; then
    sudo apt-get install openjdk-19-jdk
    echo "Java Downloaded"
fi

if [ ! -f spigot.jar ]; then
  # Download the latest version of Spigot
  wget https://download.getbukkit.org/spigot/spigot-1.19.3.jar
  mv spigot-1.19.3.jar spigot.jar
  echo "Spigot downloaded"
fi

if [ ! -f eula.txt ]; then
  echo "eula=true" > eula.txt
  echo "EULA accepted"
fi

# Create the server
/usr/lib/jvm/java-19-openjdk-amd64/bin/java -Xms1G -Xmx1G -jar spigot.jar --nogui
