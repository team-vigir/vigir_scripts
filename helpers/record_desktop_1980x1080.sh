#!/bin/bash
now="$(date +'%d-%m-%Y_%H:%M:%S')"
lightgreen='\033[1;32m'
NC='\033[0m' # No Color
ffmpeg  -s 1920x1080 -f x11grab -r 30 -i :0.0+0,0 -vcodec libx264 -preset ultrafast -threads 0 screencast_$now.mkv
echo -e "${lightgreen}Recorded to screencast_$now.mkv${NC}"
