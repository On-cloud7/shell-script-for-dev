#!/bin/bash


read -p "enter the username: " username

echo "you enter $username"
sudo useradd -m $username

echo "new user added"

