#!/bin/bash

sudo mkdir /nix;
sudo chown "$USER" /nix;
curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
sleep 45
#linking nix apps to usr/share/applications
sudo ln -s /nix/var/nix/profiles/per-user/${HOME}/profile/share/applications /usr/share/applications