#!/bin/bash

while true; do
    # Generamos el valor (SIN espacios en el = y el $(()) )
    TEMP=$(( ( RANDOM % 41 ) + 20 ))
    
    # Escribimos en el log (formato limpio)
    echo "[$(date +%T)] [TEMP] $TEMP" >> rover_system.log
    
    # IMPORTANTE: Esperar 2 segundos entre lecturas
    sleep 2
done
