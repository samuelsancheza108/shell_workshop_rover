#!/bin/bash

while true; do
	MOTOR=$(( (RANDOM % 3500) + 3000 ))
	echo "[$(date +%T)] [Motor] $MOTOR" >> rover_system.log
	sleep 2

done




