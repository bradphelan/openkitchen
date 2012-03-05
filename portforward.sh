#!/bin/sh
sudo ssh -L 80:localhost:3000 -l `whoami` -N localhost
