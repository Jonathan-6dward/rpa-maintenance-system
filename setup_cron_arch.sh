#!/bin/bash

# Script para configurar a rotina contínua de manutenção no Arch Linux (e derivados)
# Configura cronie, tarefas agendadas e aliases para os scripts do Guardiao-RPA.

# Instalar cronie se necessário
if ! command -v crontab &> /dev/null; then
    echo "Cronie não encontrado. Tentando instalar..."
    if command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm cronie
    else
        echo "Erro: Gerenciador de pacotes pacman não encontrado. Instale o cronie manualmente."
        exit 1
    fi
fi

# Iniciar e habilitar o serviço cronie
echo "Habilitando e iniciando o serviço cronie..."
sudo systemctl enable --now cronie.service

# Diretório do projeto
PROJECT_DIR="$HOME/Guardiao-RPA"

# Criar diretórios necessários
mkdir -p "$HOME/Logs"
mkdir -p "$HOME/Backups"

# Tornar todos os scripts no diretório do projeto executáveis
chmod +x "$PROJECT_DIR"/*.sh

# Adicionar aliases ao .bashrc (ou .zshrc, etc.)
# Nota: Isso adiciona ao .bashrc. Se você usa outro shell, adicione manualmente.
BASHRC_FILE="$HOME/.bashrc"

if ! grep -q "# Aliases para Guardiao-RPA" "$BASHRC_FILE"; then
    echo "" >> "$BASHRC_FILE"
    echo "# Aliases para Guardiao-RPA" >> "$BASHRC_FILE"
    echo "alias guardiao-audit='bash $PROJECT_DIR/auditoria_sistema.sh'" >> "$BASHRC_FILE"
    echo "alias guardiao-clean='bash $PROJECT_DIR/maintenance.sh'" >> "$BASHRC_FILE"
    echo "alias guardiao-full='bash $PROJECT_DIR/complete_maintenance.sh'" >> "$BASHRC_FILE"
    echo "alias guardiao-dockerclean='docker system prune -af'" >> "$BASHRC_FILE"
    echo "alias guardiao-report='bash $PROJECT_DIR/report_viewer.sh'" >> "$BASHRC_FILE"
    echo "alias guardiao-update='sudo bash $PROJECT_DIR/atualizacao_segura.sh'" >> "$BASHRC_FILE"
    echo "alias guardiao-backup='bash $PROJECT_DIR/backup_configuracoes.sh'" >> "$BASHRC_FILE"
    echo "" >> "$BASHRC_FILE"
fi

# Configurar tarefas do cron
CRON_CONTENT="
# Tarefas de manutenção do Guardiao-RPA
# Auditoria de segurança - semanal (todos os domingos às 2h)
0 2 * * 0 bash $PROJECT_DIR/executar_cron.sh $PROJECT_DIR/auditoria_sistema.sh

# Limpeza de containers - quinzenal (1º e 15º de cada mês, às 3h)
0 3 1,15 * * bash $PROJECT_DIR/executar_cron.sh $PROJECT_DIR/maintenance.sh

# Atualização segura do sistema - semanal (todos os sábados às 4h)
0 4 * * 6 sudo bash $PROJECT_DIR/executar_cron.sh $PROJECT_DIR/atualizacao_segura.sh

# Backup de configurações - semanal (todos os sábados às 5h)
0 5 * * 6 bash $PROJECT_DIR/executar_cron.sh $PROJECT_DIR/backup_configuracoes.sh

# Limpeza de logs antigos - mensal (1º de cada mês, às 6h)
0 6 1 * * bash $PROJECT_DIR/executar_cron.sh $PROJECT_DIR/limpar_logs_antigos.sh

# Manutenção completa - mensal (1º de cada mês, às 1h)
0 1 1 * * bash $PROJECT_DIR/executar_cron.sh $PROJECT_DIR/complete_maintenance.sh
"

# Adicionar tarefas de manutenção ao cron
(crontab -l 2>/dev/null | grep -v -F "# Tarefas de manutenção do Guardiao-RPA" ; echo "$CRON_CONTENT") | crontab -

# Mensagem de confirmação
echo "=== ROTINAS CONTÍNUAS DE MANUTENÇÃO CONFIGURADAS (ARCH LINUX) ==="
echo ""
echo "Serviço Cronie foi habilitado e iniciado."
echo "Tarefas agendadas do cron foram atualizadas."
echo "Aliases 'guardiao-*' foram adicionados ao seu .bashrc."
echo "Por favor, reinicie seu terminal ou execute 'source ~/.bashrc' para usar os novos aliases."
echo ""
echo "Scripts de manutenção estão em $PROJECT_DIR/"
echo "Logs de manutenção serão armazenados em $HOME/Logs/"
echo ""
