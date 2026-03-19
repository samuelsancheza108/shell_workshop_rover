#!/bin/bash

while true; do
	MOTORES=$(( (RANDOM % 3500) + 3000 ))
	echo "[$(date +%T)] [Motor] $MOTORES" >> rover_system.log
	sleep 2

done




