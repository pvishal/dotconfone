#!/bin/bash

if [ $1 == "install" ]; then
    sudo -E apt-get install ffmpeg mplayer mencoder mpv feh
fi