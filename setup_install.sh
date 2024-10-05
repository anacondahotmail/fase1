#!/bin/bash

# Definir los archivos clave
ssh_key_pub="$HOME/.ssh/id_ed25519.pub"
authorized_keys="$HOME/.ssh/authorized_keys"
bashrc="$HOME/.bashrc"
bash_profile="$HOME/.bash_profile"

# Crear una carpeta de respaldo local
backup_dir="$HOME/backup_ssh_config"
mkdir -p $backup_dir

# Función para hacer backup y eliminar archivos antiguos
backup_and_replace() {
    local file_path=$1
    local simplified_file=$2

    if [ -f "$file_path" ]; then
        echo "Haciendo backup de $file_path..."
        cp "$file_path" "$backup_dir/$(basename $file_path)"
        git add "$backup_dir/$(basename $file_path)"
        git commit -m "Backup de $(basename $file_path)"
        git push
        echo "Backup de $(basename $file_path) realizado y subido al repositorio."

        echo "Eliminando archivo original $file_path..."
        rm "$file_path"
    fi

    echo "Copiando archivo $simplified_file a $file_path..."
    cp "$simplified_file" "$file_path"
}

# Fase 1: Verificación y Backup

echo "Verificando y haciendo backup de archivos existentes..."

# Verificar y manejar archivos SSH
backup_and_replace "$ssh_key_pub" "$HOME/fase1/id_ed25519.pub"
backup_and_replace "$authorized_keys" "$HOME/fase1/authorized_keys"

# Verificar y manejar archivos de Bash
backup_and_replace "$bashrc" "$HOME/fase1/bashrc_simplificado"
backup_and_replace "$bash_profile" "$HOME/fase1/bash_profile_simplificado"

# Fase 2: Eliminar residuos SSH

echo "Eliminando cualquier residuo asociado a SSH..."
rm -rf $HOME/.ssh/*

# Fase 3: Copiar nuestros archivos

echo "Copiando nuevos archivos de configuración SSH y Bash..."

# Copiar claves SSH
cp "$HOME/fase1/id_ed25519.pub" "$HOME/.ssh/id_ed25519.pub"
cp "$HOME/fase1/authorized_keys" "$HOME/.ssh/authorized_keys"

# Copiar archivos de Bash
cp "$HOME/fase1/bashrc_simplificado" "$HOME/.bashrc"
cp "$HOME/fase1/bash_profile_simplificado" "$HOME/.bash_profile"

# Fase 4: Asignación precisa de permisos

echo "Asignando permisos correctos..."

# Asignar permisos para claves SSH
chmod 700 $HOME/.ssh
chmod 644 $HOME/.ssh/id_ed25519.pub
chmod 600 $HOME/.ssh/authorized_keys

# Asignar permisos a los archivos de Bash
chmod 644 $HOME/.bashrc
chmod 644 $HOME/.bash_profile

# Fase 5: Hacer ejecutable el script wifi_simplificado.sh

echo "Haciendo ejecutable el script wifi_simplificado.sh..."
chmod +x $HOME/fase1/wifi_simplificado.sh

# Fase 6: Ejecutar el script wifi_simplificado.sh para verificar la conexión

echo "Ejecutando wifi_simplificado.sh para verificar la conexión..."
bash $HOME/fase1/wifi_simplificado.sh

# Mensaje final de confirmación
echo "Proceso completo. Verifique la conexión SSH."
