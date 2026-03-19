#!/bin/bash

while true; do
	VALOR=$(( (RANDOM % 3500) + 3000 ))
	echo "[$(date +%T)] [Motor] $VALOR" >> rover_system.log

done




