#!/bin/bash

#this script will change your wallpaper to a random nord one
wallpaperdir='$HOME/.wallpapers'

files=($wallpaperdir/*)
randompic=`printf "%s\n" "${files[RANDOM % ${#files[@]}]}"`

feh --bg-scale "$randompic"