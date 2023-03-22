#!/usr/bin/bash

read -p "New user: " usr
useradd -m -G sudo "$usr"
read -p "New password: "
passwd "$usr"
