#!/bin/bash
# Script de atualização segura do sistema para Arch Linux
LOG_DIR="$HOME/Logs"
DATE=$(date +%Y%m%d_%H%M%S)

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Iniciando atualização segura do sistema Arch..." | tee -a "$LOG_DIR/system_update_$DATE.log"

# Atualizar sistema via pacman
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Sincronizando repositórios e atualizando sistema..." | tee -a "$LOG_DIR/system_update_$DATE.log"
sudo pacman -Syu --noconfirm >> "$LOG_DIR/system_update_$DATE.log" 2>&1

# Verificar se houve erros
if [ $? -eq 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Atualizações aplicadas com sucesso" | tee -a "$LOG_DIR/system_update_$DATE.log"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Erro ao aplicar atualizações" | tee -a "$LOG_DIR/system_update_$DATE.log"
fi

# Limpar cache do pacman
sudo pacman -Sc --noconfirm >> "$LOG_DIR/system_update_$DATE.log" 2>&1
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Cache do pacman limpo" | tee -a "$LOG_DIR/system_update_$DATE.log"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Atualização segura concluída" | tee -a "$LOG_DIR/system_update_$DATE.log"
