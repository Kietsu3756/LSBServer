#!/bin/bash

sudo killall screen
screen -d -m -S topaz_connect ./topaz_connect
screen -d -m -S topaz_game ./topaz_game
screen -d -m -S topaz_search ./topaz_search

gnome-terminal -- screen -r topaz_connect
gnome-terminal -- screen -r topaz_game
gnome-terminal -- screen -r topaz_search
