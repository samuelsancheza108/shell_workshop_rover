#!/bin/bash

<<COMMENT
# En caso de hacerlo como funciones:
generar_temp() {
    TEMP=$(( (RANDOM % 41) + 20 ))
    echo "[$(date +%T)] [TEMP] $TEMP" >> rover_system.log
}
COMMENT
generar_bateria() { 
while true; do
	BAT=$(( (RANDOM % 50) + 10))
	echo "[$(date +%T)] [BAT] $BAT" >> rover_system.log 
	sleep 2
done
}
