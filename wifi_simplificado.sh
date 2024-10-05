#!/bin/bash
# wifi_simplificado.sh

# Detectar automáticamente la interfaz WiFi del host
wifi_interface=$(ip a | grep -oP '(?<=: ).*(?=:.*state UP)' | grep -E 'wlp|wlx')

# Obtener la IP del host desde la interfaz WiFi
host_ip=$(ip a show "$wifi_interface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

# Definir el IP del "mirror" (Lenovo) como la máquina remota
# La IP del "mirror" será 192.168.100.24 (es fija para Lenovo, la otra máquina)
mirror_ip="192.168.100.24"

# Cerrar conexiones SSH anteriores
echo "Cerrando conexiones SSH anteriores..."
pkill -f "ssh jose@$mirror_ip"

# Abriendo nueva conexión SSH al "mirror"
echo "Abriendo nueva conexión SSH a $mirror_ip por WiFi desde el host $host_ip..."
ssh jose@$mirror_ip
