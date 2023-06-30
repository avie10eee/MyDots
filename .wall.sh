#!/bin/bash

#this script will change your wallpaper to a random one in ~/.wallpapers
wallpaperdir='$HOME/.wallpapers'

files=($wallpaperdir/*)
randompic=$(printf "%s\n" "${files[RANDOM % ${#files[@]}]}")

feh --bg-scale "$randompic"