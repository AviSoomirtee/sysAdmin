#!/bin/bash


echo "*******************"
echo "*                 *"
sleep 2
echo "Setup starting...."
sleep 3
echo "System check..."
sleep 5
echo "Dumping trash files..."
sleep 5
echo "Initializing cleanup..."
sleep 10

yum check-update

echo "System is update..."
echo "Checking network configurations"
sleep 3
ip a s
echo " Cheking open ports"
sleep 5
echo "Installing netstat..."
sleep 5
echo "Installation done..."
sleep 3

echo "Setup completed successfull!"
sleep 2
echo "*                 *"
echo "*******************"
echo "Rebooting"
cat LPG-LinuxGuide.txt >> /root/.bashrc
sleep 2
reboot

