#!/bin/bash


echo "priyanka is a good girls"

read -p "enter username " username

echo "you entered $username"

sudo useradd -m $username

echo "new user added"

