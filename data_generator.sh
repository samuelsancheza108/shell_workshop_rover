#!/bin/bash

while true; do
    # Rango de RPM: de 1000 a 3500
    # (RANDOM % 2501) genera 0-2500, + 1000 = 1000-3500
    RPM=$(( (RANDOM % 2501) + 1000 ))
    
    # Formato de salida
    echo "[$(date +%T)] [MOTORES] $RPM" >> rover_system.log
    
    # Frecuencia: 1Hz
    sleep 1
done
