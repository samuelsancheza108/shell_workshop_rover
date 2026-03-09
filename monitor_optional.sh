#!/bin/bash
# DASHBOARD DE CONTROL - ROVER 2026
NC='\033[0m'; CYAN='\033[0;36m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; GREEN='\033[0;32m'
LOG_FILE="rover_system.log"

# UMBRALES DE SEGURIDAD (Thresholds)
MAX_TEMP=100
MIN_BATT=0
MAX_RPM=3600
MODE="ALL"

# Función para obtener la media del log:
media_variable() {
    # Este $1 es respecto a como llamamos a la función en el script
    # NO forma parte de los parámetros que pasamos al llamar al script:
    variable="$1"   
    awk -v var="[$variable]" '
        $2 == var {
            suma += $3
            contador++
        }
        END {
            if (contador > 0)
                print "Media de", var, "=", suma/contador
            else
                print "No hay datos de", var
        }
    ' rover_system.log
    # En este caso, $2 y $3 forman parte del programa del awk (separa por espacios, $2 y $3 son las columnas)
}

# Leemos la flag que sea
MODE="all"
AVERAGE="false"

# Comprobamos que los parametros:
MODE="all"
AVERAGE="false"

for arg in "$@"; do
    case "$arg" in
        -t) MODE="temp" ;;
        -m) MODE="motores" ;;
        -b) MODE="batt" ;;
        --avg) AVERAGE="true" ;;
        -h)
            echo -e "usage: $0\n\t-t: mostrar solo temperatura\n\t-m: mostrar solo datos de motores\n\t-b: mostrar solo datos de la bateria\n\t--avg: mostrar valores medios durante la ejecucion"
            exit
            ;;
        *)
            echo "Parámetro no válido: $arg"
            exit 1
            ;;
    esac
done


clear
echo -e "${CYAN}>>> MONITOR INICIADO. ESPERANDO TELEMETRÍA... <<<\${NC}"
touch $LOG_FILE

# Leer el log en tiempo real línea a línea
tail -f $LOG_FILE | while read -r line; do
    clear
    echo -e "${CYAN}==================================================${NC}"
    echo -e "         DASHBOARD DE CONTROL - ROVER 2026        "
    echo -e "${CYAN}==================================================${NC}"
    
    # --- TAREA ALUMNOS: Extraer datos con grep y awk ---
   
    if [ "$MODE" = "all" ] || [ "$MODE" = "temp" ]; then
        # Extraemos la temperatura (Última línea que contenga [TEMP])
        TEMP=$(grep "\[TEMP\]" $LOG_FILE | tail -n 1 | awk '{print $NF}')
        # 1. Validar Temperatura
        if [ "${TEMP:-0}" -gt "$MAX_TEMP" ]; then
            echo -e "${RED}[!] ALERTA: Temperatura crítica: ${TEMP}°C (Límite: $MAX_TEMP)${NC}"
            echo "$(date +%T) [WATCHDOG] EMERGENCIA: Sobrecalentamiento detectado" >> $LOG_FILE
            # Detener el generador de datos si hay peligro
            pkill -f data_generator.sh
            echo -e "${RED}SISTEMA DETENIDO POR SEGURIDAD.${NC}"
            exit
        fi
        # Mostrar datos por pantalla
        echo -e "  TERMÓMETRO: ${YELLOW}${TEMP:-'--'}°C${NC}"
    fi

    if [ "$MODE" = "all" ] || [ "$MODE" = "batt" ]; then
        # Extraemos la Batería (Última línea que contenga [BATT])
        BATT=$(grep "\[BATT\]" $LOG_FILE | tail -n 1 | awk '{print $NF}')
        # 2. Validar Batería
        if [ "${BATT:-100}" -lt "$MIN_BATT" ]; then
            echo -e "${RED}[!] ALERTA: Batería baja: ${BATT}% (Límite: $MIN_BATT)${NC}"
            echo "$(date +%T) [WATCHDOG] AVISO: Nivel de energía crítico" >> $LOG_FILE
                # Detener el generador de datos si hay peligro
            pkill -f data_generator.sh
            echo -e "${RED}SISTEMA DETENIDO POR SEGURIDAD.${NC}"
            exit

        fi
        # Mostrar por pantalla:
        echo -e "  ENERGÍA:    ${GREEN}${BATT:-'--'}%${NC}"    
    fi
    
    if [ "$MODE" = "all" ] || [ "$MODE" = "motores" ]; then
        # Extraemos las RPM (Última línea que contenga [MOTORES])
        RPM=$(grep "\[MOTORES\]" $LOG_FILE | tail -n 1 | awk '{print $NF}')
    
        # 3. Validar Motores
        if [ "${RPM:-0}" -gt "$MAX_RPM" ]; then
            echo -e "${RED}[!] ALERTA: RPM excesivas: ${RPM} (Límite: $MAX_RPM)${NC}"
            echo "$(date +%T) [WATCHDOG] EMERGENCIA: Exceso de velocidad en motores" >> $LOG_FILE
                # Detener el generador de datos si hay peligro
            pkill -f data_generator.sh
            echo -e "${RED}SISTEMA DETENIDO POR SEGURIDAD.${NC}"
            exit
        fi

        echo -e "  MOTORES:     ${CYAN}${RPM:-'--'} RPM${NC}"
    fi

    if [ "$AVERAGE" = "true" ]; then
        echo -e "${CYAN}--------------------------------------------------${NC}"
        media_temp=$(media_variable TEMP)
        media_bat=$(media_variable BATT)
        media_motor=$(media_variable MOTORES)

        echo -e "  TEMP MEDIA:    ${YELLOW}${media_temp:-'--'}°C${NC}"
        echo -e "  ENERGÍA MEDIA: ${GREEN}${media_bat:-'--'}%${NC}"
        echo -e "  RPM MEDIA:     ${CYAN}${media_motor:-'--'} RPM${NC}"
    fi

    echo -e "${CYAN}--------------------------------------------------${NC}"
    echo -e "  ULTIMA LÍNEA RECIBIDA: $line"
    echo -e "${CYAN}--------------------------------------------------${NC}"

    
    
done
