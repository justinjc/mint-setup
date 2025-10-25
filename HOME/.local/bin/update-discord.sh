#!/usr/bin/env bash

url="https://discord.com/api/download?platform=linux&format=deb"
curl -s -L -o /tmp/discord.deb $url
sudo apt install /tmp/discord.deb
