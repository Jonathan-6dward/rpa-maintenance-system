#!/bin/bash
# Script para backup de configurações importantes
BACKUP_DIR="$HOME/Backups"
mkdir -p "$BACKUP_DIR/configs_$(date +%Y%m%d)"

# Backup de arquivos de configuração
cp /etc/hosts "$BACKUP_DIR/configs_$(date +%Y%m%d)/hosts_$(date +%Y%m%d_%H%M%S)" 2>/dev/null
cp /etc/resolv.conf "$BACKUP_DIR/configs_$(date +%Y%m%d)/resolv.conf_$(date +%Y%m%d_%H%M%S)" 2>/dev/null
cp /etc/fstab "$BACKUP_DIR/configs_$(date +%Y%m%d)/fstab_$(date +%Y%m%d_%H%M%S)" 2>/dev/null
cp /etc/ssh/sshd_config "$BACKUP_DIR/configs_$(date +%Y%m%d)/sshd_config_$(date +%Y%m%d_%H%M%S)" 2>/dev/null
cp $HOME/.bashrc "$BACKUP_DIR/configs_$(date +%Y%m%d)/bashrc_$(date +%Y%m%d_%H%M%S)" 2>/dev/null
cp $HOME/.gitconfig "$BACKUP_DIR/configs_$(date +%Y%m%d)/gitconfig_$(date +%Y%m%d_%H%M%S)" 2>/dev/null
