#!/usr/bin/env bash
set -x

echo "$P_USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/fujinet

sudo chmod 440 /etc/sudoers.d/fujinet
