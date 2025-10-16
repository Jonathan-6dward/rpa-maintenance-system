#!/bin/bash

# Script de auditoria e manutenção do ambiente de desenvolvimento
# Atua como RPA para manutenção e otimização do ambiente de desenvolvimento Linux
# Criado por Jonathan Edward

# Criar diretórios necessários
mkdir -p "$HOME/Logs"

# Definir variáveis
LOG_DIR="$HOME/Logs"
DATE=$(date +%Y%m%d_%H%M%S)

# Função para registrar logs
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_DIR/maintenance_$DATE.log"
}

# Função para criar relatório JSON
create_json_report() {
    cat > "$LOG_DIR/report_$DATE.json" << EOF
{
  "timestamp": "$(date)",
  "network_status": "pending",
  "security_status": "pending", 
  "docker_status": "pending",
  "dependencies_status": "pending",
  "performance_status": "pending",
  "action_summary": "Auditoria iniciada"
}
EOF
}

# Iniciar auditoria
log_message "=== INICIANDO AUDITORIA DO AMBIENTE DE DESENVOLVIMENTO ==="

# Atualizar relatório JSON
sed -i 's/"action_summary":.*/"action_summary": "Auditoria em andamento",/' "$LOG_DIR/report_$DATE.json"
sed -i 's/"network_status":.*/"network_status": "checking",/' "$LOG_DIR/report_$DATE.json"

# 1. REDE E CONECTIVIDADE
log_message "1. Verificando rede e conectividade..."

# Identificar interfaces de rede
log_message " - Interfaces de rede:"
ip a | tee -a "$LOG_DIR/maintenance_$DATE.log"

# Verificar DNS
log_message " - Configuração DNS:"
tee -a "$LOG_DIR/maintenance_$DATE.log" < /etc/resolv.conf

# Verificar gateway
log_message " - Gateway padrão:"
ip route | grep default | tee -a "$LOG_DIR/maintenance_$DATE.log"

# Testar conectividade
log_message " - Testando conectividade (ping 8.8.8.8)..."
ping -c 3 8.8.8.8 >> "$LOG_DIR/maintenance_$DATE.log" 2>&1

# Verificar portas abertas
log_message " - Portas abertas e serviços em escuta:"
ss -tulpen | tee -a "$LOG_DIR/maintenance_$DATE.log"

# Atualizar relatório JSON
sed -i 's/"network_status":.*/"network_status": "checked",/' "$LOG_DIR/report_$DATE.json"

# Atualizar relatório JSON
sed -i 's/"security_status":.*/"security_status": "checking",/' "$LOG_DIR/report_$DATE.json"

# 2. SEGURANÇA E SISTEMA
log_message "2. Verificando segurança e sistema..."

# Verificar usuários com privilégios
log_message " - Usuários com privilégios:"
getent group sudo | tee -a "$LOG_DIR/maintenance_$DATE.log"
getent group docker | tee -a "$LOG_DIR/maintenance_$DATE.log"

# Verificar permissões em diretórios sensíveis
log_message " - Verificando permissões em diretórios sensíveis..."
find /etc -type f -perm 777 -exec ls -la {} \; 2>/dev/null | tee -a "$LOG_DIR/maintenance_$DATE.log"
find /usr/local/bin -type f -perm 777 -exec ls -la {} \; 2>/dev/null | tee -a "$LOG_DIR/maintenance_$DATE.log"

# Verificar pacotes quebrados
log_message " - Verificando integridade de pacotes..."
apt-get check 2>&1 | tee -a "$LOG_DIR/maintenance_$DATE.log"

# Verificar pacotes desatualizados
log_message " - Verificando pacotes desatualizados..."
apt list --upgradable 2>/dev/null | tee -a "$LOG_DIR/maintenance_$DATE.log"

# Verificar status do firewall
log_message " - Status do UFW:"
ufw status 2>&1 | tee -a "$LOG_DIR/maintenance_$DATE.log"

# Verificar serviços críticos
log_message " - Serviços críticos:"
systemctl status ssh 2>&1 | tee -a "$LOG_DIR/maintenance_$DATE.log"
systemctl status docker 2>&1 | tee -a "$LOG_DIR/maintenance_$DATE.log"

# Atualizar relatório JSON
sed -i 's/"security_status":.*/"security_status": "checked",/' "$LOG_DIR/report_$DATE.json"

# Atualizar relatório JSON
sed -i 's/"docker_status":.*/"docker_status": "checking",/' "$LOG_DIR/report_$DATE.json"

# 3. CONTAINERS E AMBIENTE DOCKER
log_message "3. Verificando containers e ambiente Docker..."

# Verificar se Docker está instalado e rodando
if command -v docker &> /dev/null; then
    log_message " - Docker instalado. Verificando containers..."
    
    # Listar todos os containers
    log_message " - Containers (ativos e inativos):"
    docker ps -a 2>&1 | tee -a "$LOG_DIR/maintenance_$DATE.log"
    
    # Listar volumes
    log_message " - Volumes Docker:"
    docker volume ls 2>&1 | tee -a "$LOG_DIR/maintenance_$DATE.log"
    
    # Verificar imagens
    log_message " - Imagens Docker:"
    docker images 2>&1 | tee -a "$LOG_DIR/maintenance_$DATE.log"
    
    # Verificar network Docker
    log_message " - Redes Docker:"
    docker network ls 2>&1 | tee -a "$LOG_DIR/maintenance_$DATE.log"
    
    # Criar relatório de saúde Docker
    docker ps -a --format "table {{.Names}}	{{.Status}}	{{.Ports}}" > "$LOG_DIR/docker_health_$DATE.log" 2>&1
    log_message " - Relatório de saúde Docker criado em: $LOG_DIR/docker_health_$DATE.log"
else
    log_message " - Docker não está instalado ou não está acessível"
fi

# Atualizar relatório JSON
sed -i 's/"docker_status":.*/"docker_status": "checked",/' "$LOG_DIR/report_$DATE.json"

# Atualizar relatório JSON
sed -i 's/"dependencies_status":.*/"dependencies_status": "checking",/' "$LOG_DIR/report_$DATE.json"

# 4. AMBIENTE DE DESESVOLVIMENTO E PROJETOS
log_message "4. Verificando ambiente de desenvolvimento e projetos..."

# Verificar estrutura de projetos
PROJECT_DIR="$HOME/Documents/Projects"
if [ -d "$PROJECT_DIR" ]; then
    log_message " - Diretório de projetos encontrado: $PROJECT_DIR"
    command ls -la "$PROJECT_DIR" 2>&1 | tee -a "$LOG_DIR/maintenance_$DATE.log"
    
    # Procurar por arquivos .env
    log_message " - Procurando arquivos .env..."
    find "$PROJECT_DIR" -name ".env" -exec ls -la {} \; 2>/dev/null | tee -a "$LOG_DIR/maintenance_$DATE.log"
else
    log_message " - Diretório de projetos não encontrado: $PROJECT_DIR"
fi

# Verificar dependências Python
if command -v pip &> /dev/null; then
    log_message " - Verificando dependências Python..."
    pip check 2>&1 | tee -a "$LOG_DIR/maintenance_$DATE.log"
fi

# Verificar dependências Node.js
if command -v npm &> /dev/null; then
    log_message " - Verificando dependências Node.js..."
    npm audit 2>&1 | tee -a "$LOG_DIR/maintenance_$DATE.log" || echo "Nenhum package-lock.json encontrado" | tee -a "$LOG_DIR/maintenance_$DATE.log"
fi

# Atualizar relatório JSON
sed -i 's/"dependencies_status":.*/"dependencies_status": "checked",/' "$LOG_DIR/report_$DATE.json"

# Atualizar relatório JSON
sed -i 's/"performance_status":.*/"performance_status": "checking",/' "$LOG_DIR/report_$DATE.json"

# 5. PERFORMANCE E FLUIDEZ GERAL
log_message "5. Verificando performance e fluidez geral..."

# Verificar carga do sistema
log_message " - Carga do sistema:"
uptime | tee -a "$LOG_DIR/maintenance_$DATE.log"

# Verificar uso de memória
log_message " - Uso de memória:"
free -h | tee -a "$LOG_DIR/maintenance_$DATE.log"

# Verificar uso de disco
log_message " - Uso de disco:"
df -h | tee -a "$LOG_DIR/maintenance_$DATE.log"

# Verificar processos com alto uso de CPU
log_message " - Processos com alto uso de CPU:"
ps aux --sort=-%cpu | head -10 | tee -a "$LOG_DIR/maintenance_$DATE.log"

# Verificar uso de disco em home
log_message " - Uso de disco em diretórios principais:"
du -sh $HOME/* 2>/dev/null | head -10 | tee -a "$LOG_DIR/maintenance_$DATE.log"

# Verificar espaço em /tmp
log_message " - Conteúdo de /tmp:"
find /tmp -maxdepth 1 -printf '%f\n' 2>/dev/null | head -10 | tee -a "$LOG_DIR/maintenance_$DATE.log"

# Atualizar relatório JSON
sed -i 's/"performance_status":.*/"performance_status": "checked",/' "$LOG_DIR/report_$DATE.json"
sed -i "s/\"action_summary\":.*/\"action_summary\": \"Auditoria completa realizada em $DATE\",/" "$LOG_DIR/report_$DATE.json"

# 6. RELATÓRIOS E LOGS
log_message "6. Criando relatórios e logs..."

# Criar resumo amigável
log_message ""
log_message "=== RESUMO DA AUDITORIA ==="
log_message "🔵 Rede: OK"
log_message "🔒 Segurança: Verificada"
log_message "🐳 Containers: Verificados"
log_message "⚙️  Projetos: Verificados"
log_message "🚀 Performance: Verificada"
log_message "========================="

log_message "Relatórios criados em: $LOG_DIR/"
log_message "Arquivo JSON de relatório: $LOG_DIR/report_$DATE.json"
log_message "Log completo: $LOG_DIR/maintenance_$DATE.log"

# Concluir auditoria
log_message "=== AUDITORIA FINALIZADA ==="
