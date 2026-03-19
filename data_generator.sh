#!/bin/bash

<<COMMENT
# En caso de hacerlo como funciones:
generar_temp() {
    TEMP=$(( (RANDOM % 41) + 20 ))
    echo "[$(date +%T)] [TEMP] $TEMP" >> rover_system.log
}
COMMENT

while true; do

done
