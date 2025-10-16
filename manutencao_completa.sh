#!/bin/bash

# Este script executa uma sequência de scripts de manutenção.
# Garanta que todos os scripts chamados estejam no mesmo diretório e tenham permissão de execução.

echo "--- Iniciando Manutenção Completa: $(date) ---"

echo "--> Executando atualizacao_segura.sh"
bash ./atualizacao_segura.sh

echo "--> Executando maintenance.sh (Limpeza de Contêineres)"
bash ./maintenance.sh

echo "--> Executando backup_configuracoes.sh"
bash ./backup_configuracoes.sh

echo "--> Executando limpar_logs_antigos.sh"
bash ./limpar_logs_antigos.sh

echo "--- Manutenção Completa Finalizada: $(date) ---"