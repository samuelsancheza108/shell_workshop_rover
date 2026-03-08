#!/bin/bash
# DASHBOARD DE CONTROL - ROVER 2026
NC='\033[0m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; GREEN='\033[0;32m'
LOG_FILE="rover_system.log"
touch $LOG_FILE

clear
echo -e "${CYAN}>>> MONITOR INICIADO. ESPERANDO TELEMETRÍA... <<<\${NC}"

# Leer el log en tiempo real línea a línea
tail -f $LOG_FILE | while read -r line; do
    clear
    echo -e "${CYAN}==================================================${NC}"
    echo -e "         DASHBOARD DE CONTROL - ROVER 2026        "
    echo -e "${CYAN}==================================================${NC}"
    
    # --- TAREA ALUMNOS: Extraer datos con grep y awk ---
    # Ejemplo: TEMP=$(grep "TEMP" $LOG_FILE | tail -n 1 | awk '{print $NF}')
    
    echo -e "  ULTIMA LÍNEA RECIBIDA: $line"
    echo -e "${CYAN}--------------------------------------------------${NC}"
    
    # --- TAREA ALUMNOS: Lógica de Watchdog para 'CRITICAL' ---
done
