#!/bin/bash

echo "==========Installing Headless Chrome and Chromedriver=========="
#sudo apt-get update
#sudo apt-get install -y openjdk-8-jre-headless xvfb libxi6 libgconf-2-4

# Install Chrome.
wget -N https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P /tmp 
sudo dpkg -i --force-depends /tmp/google-chrome-stable_current_amd64.deb
apt-get -f install -y
sudo dpkg -i --force-depends /tmp/google-chrome-stable_current_amd64.deb

# Install ChromeDriver.
wget -N http://chromedriver.storage.googleapis.com/2.27/chromedriver_linux64.zip -P /tmp 
cd /tmp
sudo apt-get install unzip
sudo unzip chromedriver_linux64.zip -d /tmp
sudo rm /tmp/chromedriver_linux64.zip
sudo mv -f /tmp/chromedriver /usr/local/share/
sudo chmod +x /usr/local/share/chromedriver
sudo ln -s /usr/local/share/chromedriver /usr/local/bin/chromedriver

