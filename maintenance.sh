#!/bin/bash

# Script de limpeza do ambiente de desenvolvimento
# Realiza limpeza de containers, pacotes órfãos, arquivos temporários, etc.
# Criado por Jonathan Edward

# Variáveis
LOG_DIR="$HOME/Logs"
# SCRIPT_DIR="$HOME/Guardiao-RPA"  # Removido pois não está sendo usado
DATE=$(date +%Y%m%d_%H%M%S)

# Função para registrar logs
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_DIR/clean_$DATE.log"
}

# Iniciar limpeza
log_message "=== INICIANDO LIMPEZA DO AMBIENTE DE DESENVOLVIMENTO ==="

# 1. LIMPEZA DE CONTAINERS E IMAGENS DOCKER
if command -v docker &> /dev/null; then
    log_message "1. Limpando containers e imagens Docker..."
    
    # Parar containers inativos
    log_message " - Parando containers inativos..."
    docker stop "$(docker ps -aq)" 2>/dev/null
    
    # Remover containers parados
    log_message " - Removendo containers parados..."
    docker rm "$(docker ps -aq)" 2>/dev/null
    
    # Remover imagens não utilizadas
    log_message " - Removendo imagens não utilizadas..."
    docker image prune -af 2>&1 | tee -a "$LOG_DIR/clean_$DATE.log"
    
    # Remover volumes órfãos
    log_message " - Removendo volumes órfãos..."
    docker volume prune -f 2>&1 | tee -a "$LOG_DIR/clean_$DATE.log"
    
    # Remover redes órfãs
    log_message " - Removendo redes órfãs..."
    docker network prune -f 2>&1 | tee -a "$LOG_DIR/clean_$DATE.log"
    
    # Remover builds órfãos
    log_message " - Removendo builds órfãos..."
    docker builder prune -af 2>&1 | tee -a "$LOG_DIR/clean_$DATE.log"
    
else
    log_message "Docker não está instalado ou não está acessível"
fi

# 2. LIMPEZA DE PACOTES SISTEMA
log_message "2. Limpando pacotes do sistema..."

# Remover pacotes órfãos
log_message " - Removendo pacotes órfãos..."
apt autoremove -y 2>&1 | tee -a "$LOG_DIR/clean_$DATE.log"

# Limpar cache do apt
log_message " - Limpando cache do apt..."
apt autoclean 2>&1 | tee -a "$LOG_DIR/clean_$DATE.log"
apt clean 2>&1 | tee -a "$LOG_DIR/clean_$DATE.log"

# 3. LIMPEZA DE ARQUIVOS TEMPORÁRIOS
log_message "3. Limpando arquivos temporários..."

# Limpar /tmp
log_message " - Limpando /tmp..."
rm -rf /tmp/* 2>/dev/null
rm -rf /tmp/.* 2>/dev/null

# Limpar cache de usuário
log_message " - Limpando cache de usuário..."
rm -rf $HOME/.cache/* 2>/dev/null

# Limpar logs antigos (mais de 7 dias)
log_message " - Limpando logs antigos (mais de 7 dias)..."
find /var/log -name "*.log" -mtime +7 -delete 2>/dev/null
find "$LOG_DIR" -name "*.log" -mtime +7 -delete 2>/dev/null

# 4. LIMPEZA DE PROJETOS
log_message "4. Limpando projetos..."

# Limpar arquivos de cache de projetos Python
find $HOME/Documents/Projects -name "__pycache__" -exec rm -rf {} + 2>/dev/null
find $HOME/Documents/Projects -name "*.pyc" -delete 2>/dev/null

# Limpar node_modules antigos (opcional - comentar se não quiser remover)
# find $HOME/Documents/Projects -name "node_modules" -type d -exec rm -rf {} + 2>/dev/null

# 5. RELATÓRIO DE LIMPEZA
log_message "5. Limpando informações de sistema..."

# Verificar uso de disco após limpeza
log_message " - Uso de disco após limpeza:"
df -h | tee -a "$LOG_DIR/clean_$DATE.log"

log_message "=== LIMPEZA FINALIZADA ==="
log_message "Arquivo de log: $LOG_DIR/clean_$DATE.log"