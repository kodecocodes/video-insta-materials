#! /usr/bin/env bash

# Fix for Debian 9 (need to match the version of openssl)
# https://stackoverflow.com/questions/51560964/how-to-upgrade-openssl-from-1-0-2g-to-1-1-0g-in-ubuntu-and-let-python-recognize/51565653#51565653
wget https://www.openssl.org/source/old/1.1.0/openssl-1.1.0g.tar.gz
tar xzvf openssl-1.1.0g.tar.gz
cd openssl-1.1.0g
./config
make
sudo make install
openssl version -a
swift build -c release
