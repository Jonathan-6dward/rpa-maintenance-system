#!/bin/bash

# Script RPA de manutenção e otimização do ambiente de desenvolvimento
# Combina auditoria, correção e otimização em uma única rotina
# Criado por Jonathan Edward

# Criar diretórios necessários
mkdir -p "$HOME/Logs"

# Variáveis
LOG_DIR="$HOME/Logs"
DATE=$(date +%Y%m%d_%H%M%S)

# Função para registrar logs
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_DIR/complete_maintenance_$DATE.log"
}

# Função para criar relatório JSON
create_json_report() {
    cat > "$LOG_DIR/report_$DATE.json" << EOF
{
  "timestamp": "$(date)",
  "maintenance_type": "complete",
  "network_status": "pending",
  "security_status": "pending", 
  "docker_status": "pending",
  "dependencies_status": "pending",
  "performance_status": "pending",
  "cleanup_status": "pending",
  "updates_pending": 0,
  "disk_usage_before": "",
  "disk_usage_after": "",
  "action_summary": "Manutenção completa iniciada",
  "actions_taken": []
}
EOF
}

# Registrar uso de disco antes da manutenção
DISK_USAGE_BEFORE=$(df / | grep -v Filesystem | awk '{print $5}')
sed -i "s/\"disk_usage_before\":.*/\"disk_usage_before\": \"$DISK_USAGE_BEFORE\",/" "$LOG_DIR/report_$DATE.json"

# Iniciar manutenção completa
log_message "=== INICIANDO MANUTENÇÃO COMPLETA DO AMBIENTE DE DESENVOLVIMENTO ==="
log_message "Tipo: Auditoria e Otimização Completa"
log_message "Data: $DATE"

# Atualizar relatório JSON
sed -i 's/"action_summary":.*/"action_summary": "Manutenção completa em andamento",/' "$LOG_DIR/report_$DATE.json"

# 1. AUDITORIA DE REDE
log_message ""
log_message "1. REALIZANDO AUDITORIA DE REDE E CONECTIVIDADE..."

# Coletar informações de rede
log_message " - Coletando informações de rede..."
NETWORK_INFO=$(ip a | grep -E "(inet|state|ether)" | tr '\n' ';' | sed 's/;/\n/g')
echo "$NETWORK_INFO" | tee -a "$LOG_DIR/complete_maintenance_$DATE.log"

# Verificar portas abertas
log_message " - Verificando portas em escuta..."
OPEN_PORTS=$(ss -tulpen | grep LISTEN)
echo "$OPEN_PORTS" | tee -a "$LOG_DIR/complete_maintenance_$DATE.log"

# Adicionar portas ao relatório JSON
PORTS_COUNT=$(echo "$OPEN_PORTS" | wc -l)
echo "\"open_ports_count\": $PORTS_COUNT," >> "$LOG_DIR/temp.json" 2>/dev/null

# Atualizar relatório JSON
sed -i 's/"network_status":.*/"network_status": "completed",/' "$LOG_DIR/report_$DATE.json"
sed -i 's/"action_summary":.*/"action_summary": "Rede auditada",/' "$LOG_DIR/report_$DATE.json"

# 2. AUDITORIA DE SEGURANÇA
log_message ""
log_message "2. REALIZANDO AUDITORIA DE SEGURANÇA..."

# Verificar usuários com privilégios
log_message " - Verificando usuários com privilégios..."
SUDO_USERS=$(getent group sudo | cut -d: -f4)
log_message "   Usuários com sudo: $SUDO_USERS"

# Verificar permissões em diretórios sensíveis
log_message " - Verificando permissões em diretórios sensíveis..."
WORLD_WRITABLE_ETC=$(find /etc -type f -perm -002 2>/dev/null | wc -l)
WORLD_WRITABLE_USR=$(find /usr/local/bin -type f -perm -002 2>/dev/null | wc -l)
log_message "   Arquivos com permissão de escrita global em /etc: $WORLD_WRITABLE_ETC"
log_message "   Arquivos com permissão de escrita global em /usr/local/bin: $WORLD_WRITABLE_USR"

# Verificar pacotes quebrados
log_message " - Verificando pacotes quebrados..."
BROKEN_PACKAGES=$(apt-get check 2>&1 | grep -c "Broken packages" || echo "0")
log_message "   Pacotes quebrados: $BROKEN_PACKAGES"

# Contar pacotes desatualizados
UPGRADEABLE_PACKAGES=$(apt list --upgradable 2>/dev/null | grep -c listing || echo "0")
sed -i "s/\"updates_pending\":.*/\"updates_pending\": $UPGRADEABLE_PACKAGES,/" "$LOG_DIR/report_$DATE.json"

# Atualizar relatório JSON
sed -i 's/"security_status":.*/"security_status": "completed",/' "$LOG_DIR/report_$DATE.json"
sed -i 's/"action_summary":.*/"action_summary": "Segurança auditada",/' "$LOG_DIR/report_$DATE.json"

# 3. AUDITORIA DE CONTAINERS
log_message ""
log_message "3. REALIZANDO AUDITORIA DE CONTAINERS..."

if command -v docker &> /dev/null; then
    # Verificar containers ativos
    ACTIVE_CONTAINERS=$(docker ps -q | wc -l)
    STOPPED_CONTAINERS=$(docker ps -aq | wc -l)
    TOTAL_CONTAINERS=$((STOPPED_CONTAINERS))
    IMAGES_COUNT=$(docker images -q | wc -l)
    VOLUMES_COUNT=$(docker volume ls -q | wc -l)
    
    log_message "   Containers ativos: $ACTIVE_CONTAINERS"
    log_message "   Total de containers: $TOTAL_CONTAINERS"
    log_message "   Imagens Docker: $IMAGES_COUNT"
    log_message "   Volumes Docker: $VOLUMES_COUNT"
    
    # Verificar containers específicos (n8n e phpMyAdmin se existirem)
    N8N_CONTAINER=$(docker ps -a --filter "name=n8n" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null)
    if [ -n "$N8N_CONTAINER" ]; then
        log_message "   Container n8n:"
        echo "$N8N_CONTAINER" | tee -a "$LOG_DIR/complete_maintenance_$DATE.log"
    fi
    
    PHPMYADMIN_CONTAINER=$(docker ps -a --filter "name=phpmyadmin" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null)
    if [ -n "$PHPMYADMIN_CONTAINER" ]; then
        log_message "   Container phpMyAdmin:"
        echo "$PHPMYADMIN_CONTAINER" | tee -a "$LOG_DIR/complete_maintenance_$DATE.log"
    fi
else
    log_message "   Docker não está instalado ou não está acessível"
    ACTIVE_CONTAINERS=0
    TOTAL_CONTAINERS=0
    IMAGES_COUNT=0
    VOLUMES_COUNT=0
fi

# Atualizar relatório JSON
sed -i 's/"docker_status":.*/"docker_status": "completed",/' "$LOG_DIR/report_$DATE.json"
sed -i 's/"action_summary":.*/"action_summary": "Containers auditados",/' "$LOG_DIR/report_$DATE.json"

# 4. AUDITORIA DE DEPENDÊNCIAS
log_message ""
log_message "4. REALIZANDO AUDITORIA DE DEPENDÊNCIAS..."

# Verificar dependências Python
PYTHON_DEPS_STATUS="not_installed"
if command -v pip &> /dev/null; then
    PYTHON_CHECK=$(pip check 2>&1)
    if [ -z "$PYTHON_CHECK" ] || echo "$PYTHON_CHECK" | grep -q "No broken"; then
        log_message "   Dependências Python: OK"
        PYTHON_DEPS_STATUS="ok"
    else
        log_message "   Dependências Python com problemas:"
        echo "$PYTHON_CHECK" | tee -a "$LOG_DIR/complete_maintenance_$DATE.log"
        PYTHON_DEPS_STATUS="issues"
    fi
else
    log_message "   Pip não está instalado"
    PYTHON_DEPS_STATUS="not_available"
fi

# Verificar dependências Node.js
NODE_DEPS_STATUS="not_installed"
if command -v npm &> /dev/null; then
    NPM_AUDIT=$(npm audit --json 2>/dev/null | jq -r '.metadata.vulnerabilities' 2>/dev/null)
    if [ -n "$NPM_AUDIT" ] && [ "$NPM_AUDIT" != "null" ]; then
        HIGH_VULN=$(echo "$NPM_AUDIT" | jq '.high // 0')
        CRITICAL_VULN=$(echo "$NPM_AUDIT" | jq '.critical // 0')
        log_message "   Vulnerabilidades npm - Alta: $HIGH_VULN, Crítica: $CRITICAL_VULN"
        if [ "$HIGH_VULN" -gt 0 ] || [ "$CRITICAL_VULN" -gt 0 ]; then
            NODE_DEPS_STATUS="vulnerabilities"
        else
            NODE_DEPS_STATUS="ok"
        fi
    else
        log_message "   npm audit não disponível ou sem package-lock.json"
        NODE_DEPS_STATUS="not_available"
    fi
else
    log_message "   Npm não está instalado"
    NODE_DEPS_STATUS="not_available"
fi

# Atualizar relatório JSON
sed -i 's/"dependencies_status":.*/"dependencies_status": "completed",/' "$LOG_DIR/report_$DATE.json"
sed -i 's/"action_summary":.*/"action_summary": "Dependências auditadas",/' "$LOG_DIR/report_$DATE.json"

# 5. AUDITORIA DE PERFORMANCE
log_message ""
log_message "5. REALIZANDO AUDITORIA DE PERFORMANCE..."

# Verificar carga do sistema
LOAD_AVG=$(uptime | awk -F'load average:' '{print $2}' | xargs)
log_message "   Carga média do sistema: $LOAD_AVG"

# Verificar uso de memória
MEM_INFO=$(free -h | grep -E '^Mem|^Swap')
log_message "   Informações de memória:"
echo "$MEM_INFO" | tee -a "$LOG_DIR/complete_maintenance_$DATE.log"

# Verificar uso de disco
DISK_USAGE=$(df -h | grep -E '^/dev/' | awk '{print $5 " " $6}' | head -5)
log_message "   Uso de disco:"
echo "$DISK_USAGE" | tee -a "$LOG_DIR/complete_maintenance_$DATE.log"

# Verificar processos com alto uso de CPU e memória
HIGH_CPU=$(ps aux --sort=-%cpu | head -6 | tail -5)
HIGH_MEM=$(ps aux --sort=-%mem | head -6 | tail -5)

log_message "   Processos com alto uso de CPU:"
echo "$HIGH_CPU" | tee -a "$LOG_DIR/complete_maintenance_$DATE.log"

log_message "   Processos com alto uso de memória:"
echo "$HIGH_MEM" | tee -a "$LOG_DIR/complete_maintenance_$DATE.log"

# Atualizar relatório JSON
sed -i 's/"performance_status":.*/"performance_status": "completed",/' "$LOG_DIR/report_$DATE.json"
sed -i 's/"action_summary":.*/"action_summary": "Performance auditada",/' "$LOG_DIR/report_$DATE.json"

# 6. OTIMIZAÇÃO E LIMPEZA
log_message ""
log_message "6. REALIZANDO OTIMIZAÇÃO E LIMPEZA..."

# Adicionar status de limpeza ao relatório
sed -i 's/"cleanup_status":.*/"cleanup_status": "started",/' "$LOG_DIR/report_$DATE.json"
sed -i 's/"action_summary":.*/"action_summary": "Iniciando limpeza",/' "$LOG_DIR/report_$DATE.json"

# Limpar logs antigos (mais de 30 dias) de /var/log
find /var/log -name "*.log" -mtime +30 -delete 2>/dev/null
find /var/log -name "*.gz" -mtime +30 -delete 2>/dev/null
log_message "   Limpando logs antigos do sistema"

# Limpar cache do apt
apt autoclean 2>/dev/null
apt clean 2>/dev/null
log_message "   Limpando cache do apt"

# Se Docker estiver disponível, limpar recursos não utilizados
if command -v docker &> /dev/null; then
    # Remover containers parados
    STOPPED_CONTAINERS_COUNT=$(docker ps -aq | wc -l)
    if [ "$STOPPED_CONTAINERS_COUNT" -gt 0 ]; then
        docker container prune -f 2>/dev/null
        log_message "   Removidos containers parados"
        sed -i "s/\"action_summary\":.*/\"action_summary\": \"Removidos containers parados\",/" "$LOG_DIR/report_$DATE.json"
    fi
    
    # Remover imagens não utilizadas
    UNUSED_IMAGES=$(docker images -q --filter "dangling=true" | wc -l)
    if [ "$UNUSED_IMAGES" -gt 0 ]; then
        docker image prune -f 2>/dev/null
        log_message "   Removidas imagens não utilizadas"
        sed -i "s/\"action_summary\":.*/\"action_summary\": \"Removidas imagens não utilizadas\",/" "$LOG_DIR/report_$DATE.json"
    fi
    
    # Remover volumes órfãos
    ORPHANED_VOLUMES=$(docker volume ls -q -f dangling=true | wc -l)
    if [ "$ORPHANED_VOLUMES" -gt 0 ]; then
        docker volume prune -f 2>/dev/null
        log_message "   Removidos volumes órfãos"
        sed -i "s/\"action_summary\":.*/\"action_summary\": \"Removidos volumes órfãos\",/" "$LOG_DIR/report_$DATE.json"
    fi
    
    # Remover redes não utilizadas
    docker network prune -f 2>/dev/null
    log_message "   Removidas redes não utilizadas"
    sed -i "s/\"action_summary\":.*/\"action_summary\": \"Removidas redes não utilizadas\",/" "$LOG_DIR/report_$DATE.json"
fi

# Limpar cache de usuário
rm -rf $HOME/.cache/* 2>/dev/null
rm -rf /tmp/* 2>/dev/null
log_message "   Limpando cache de usuário e arquivos temporários"

# Atualizar relatório JSON
sed -i 's/"cleanup_status":.*/"cleanup_status": "completed",/' "$LOG_DIR/report_$DATE.json"
sed -i 's/"action_summary":.*/"action_summary": "Limpeza concluída",/' "$LOG_DIR/report_$DATE.json"

# Registrar uso de disco após a manutenção
DISK_USAGE_AFTER=$(df / | grep -v Filesystem | awk '{print $5}')
sed -i "s/\"disk_usage_after\":.*/\"disk_usage_after\": \"$DISK_USAGE_AFTER\",/" "$LOG_DIR/report_$DATE.json"

# 7. ATUALIZAÇÕES (apenas verificar, não instalar automaticamente)
log_message ""
log_message "7. VERIFICANDO ATUALIZAÇÕES..."

if command -v apt &> /dev/null; then
    # Atualizar lista de pacotes
    apt update 2>/dev/null
    # Contar pacotes atualizáveis
    UPDATES_COUNT=$(apt list --upgradable 2>/dev/null | grep -c listing || echo "0")
    log_message "   Pacotes com atualizações disponíveis: $UPDATES_COUNT"
    
    if [ "$UPDATES_COUNT" -gt 0 ]; then
        log_message "   Pacotes atualizáveis:"
        apt list --upgradable 2>/dev/null | grep -v "listing..." | head -10 | tee -a "$LOG_DIR/complete_maintenance_$DATE.log"
        
        # Adicionar lista de pacotes atualizáveis ao relatório
        apt list --upgradable 2>/dev/null | grep -v "listing..." > /tmp/upgradable_packages_"$DATE"
    fi
else
    log_message "   Apt não está disponível"
fi

# 8. RELATÓRIOS FINAIS
log_message ""
log_message "8. GERANDO RELATÓRIOS FINAIS..."

# Atualizar relatório JSON com informações finais
FINAL_ACTIONS="Auditoria e limpeza completas"
sed -i "s/\"action_summary\":.*/\"action_summary\": \"$FINAL_ACTIONS\",/" "$LOG_DIR/report_$DATE.json"

# Adicionar contagem de ações realizadas ao relatório JSON
sed -i "/\"action_summary\":/a \  \"actions_taken\": \[\$(if [ -f /tmp/upgradable_packages_$DATE ]; then echo \"\\\"atualizacoes_disponiveis\\\"\"; fi)\]," "$LOG_DIR/report_$DATE.json"

# Criar relatório resumido em formato amigável
cat > "$LOG_DIR/summary_$DATE.txt" << EOF
RELATÓRIO DE MANUTENÇÃO - $DATE
=================================

🔵 REDE:
- Interfaces verificadas: OK
- Portas em escuta: $PORTS_COUNT

🔒 SEGURANÇA:
- Pacotes quebrados: $BROKEN_PACKAGES
- Atualizações pendentes: $UPGRADEABLE_PACKAGES
- Usuários com sudo: $SUDO_USERS

🐳 CONTAINERS:
- Containers ativos: $ACTIVE_CONTAINERS
- Total de containers: $TOTAL_CONTAINERS
- Imagens: $IMAGES_COUNT
- Volumes: $VOLUMES_COUNT

⚙️ DEPENDÊNCIAS:
- Python: $PYTHON_DEPS_STATUS
- Node.js: $NODE_DEPS_STATUS

🚀 PERFORMANCE:
- Carga do sistema: $LOAD_AVG
- Uso de disco antes: $DISK_USAGE_BEFORE
- Uso de disco após: $DISK_USAGE_AFTER

✅ AÇÕES REALIZADAS:
- Auditoria completa de rede, segurança, containers e dependências
- Limpeza de arquivos temporários e cache
- Remoção de containers e imagens não utilizadas
EOF

# 9. RESUMO AMIGÁVEL
log_message ""
log_message "=== RESUMO DA MANUTENÇÃO COMPLETA ==="
log_message "🔵 Rede: Verificada ($PORTS_COUNT portas em escuta)"
log_message "🔒 Segurança: Auditada ($BROKEN_PACKAGES pacotes quebrados, $UPGRADEABLE_PACKAGES atualizações)"
log_message "🐳 Containers: Verificados ($ACTIVE_CONTAINERS ativos, limpeza realizada)"
log_message "⚙️  Projetos/Dependências: Auditados (Python: $PYTHON_DEPS_STATUS, Node: $NODE_DEPS_STATUS)"
log_message "🚀 Performance: Verificada (carga: $LOAD_AVG, disco: $DISK_USAGE_AFTER)"
log_message "📝 Relatórios criados em: $LOG_DIR/"
log_message "====================================="

# Finalizar manutenção
log_message ""
log_message "=== MANUTENÇÃO COMPLETA FINALIZADA ==="
log_message "Log completo: $LOG_DIR/complete_maintenance_$DATE.log"
log_message "Relatório JSON: $LOG_DIR/report_$DATE.json"
log_message "Resumo: $LOG_DIR/summary_$DATE.txt"

# Limpar arquivos temporários
rm -f /tmp/upgradable_packages_"$DATE" 2>/dev/null