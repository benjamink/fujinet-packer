#!/usr/bin/env bash
set -x

echo "$P_USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/fujinet

sudo chmod 440 /etc/sudoers.d/fujinet
