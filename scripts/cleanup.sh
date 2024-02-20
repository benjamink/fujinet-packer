#!/usr/bin/env bash
set -x

sudo apt clean all 
sudo rm -f /var/log/*.log.*

for i in /var/log/*.log 
do
  echo "" | sudo tee "$i"
done

dd if=/dev/zero of=zerofile bs=128M count=100000 || true
rm -f zerofile 
