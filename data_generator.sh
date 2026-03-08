#!/bin/bash

while true; do
    # Rango de Batería: 5 a 100%
    BATT=$(( (RANDOM % 96) + 5 ))
    
    # Formato de salida
    echo "[$(date +%T)] [BATT] $BATT" >> rover_system.log
    
    # Frecuencia: 0.2Hz (Cada 5 segundos)
    sleep 5
done
