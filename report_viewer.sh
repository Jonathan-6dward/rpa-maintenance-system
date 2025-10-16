#!/bin/bash

# Script para visualizar e analisar relatórios de manutenção
# Mostra os resultados da auditoria de forma amigável
# Criado por Jonathan Edward

# Diretório de logs
LOG_DIR="$HOME/Logs"

# Função para mostrar último relatório
show_latest_report() {
    echo "=== ÚLTIMO RELATÓRIO DE MANUTENÇÃO ==="
    
    # Encontrar o arquivo de relatório mais recente
    LATEST_JSON=$(find "$LOG_DIR" -name "report_*.json" -printf '%T@ %p\n' 2>/dev/null | sort -n -r | head -n 1 | cut -d' ' -f2-)
    LATEST_SUMMARY=$(find "$LOG_DIR" -name "summary_*.txt" -printf '%T@ %p\n' 2>/dev/null | sort -n -r | head -n 1 | cut -d' ' -f2-)
    
    if [ -n "$LATEST_JSON" ] && [ -f "$LATEST_JSON" ]; then
        echo "Arquivo JSON: $(basename "$LATEST_JSON")"
        echo ""
        
        # Exibir informações principais do JSON
        TIMESTAMP=$(jq -r '.timestamp' "$LATEST_JSON" 2>/dev/null)
        NETWORK_STATUS=$(jq -r '.network_status' "$LATEST_JSON" 2>/dev/null)
        SECURITY_STATUS=$(jq -r '.security_status' "$LATEST_JSON" 2>/dev/null)
        DOCKER_STATUS=$(jq -r '.docker_status' "$LATEST_JSON" 2>/dev/null)
        DEPENDENCIES_STATUS=$(jq -r '.dependencies_status' "$LATEST_JSON" 2>/dev/null)
        PERFORMANCE_STATUS=$(jq -r '.performance_status' "$LATEST_JSON" 2>/dev/null)
        CLEANUP_STATUS=$(jq -r '.cleanup_status' "$LATEST_JSON" 2>/dev/null)
        UPDATES_PENDING=$(jq -r '.updates_pending' "$LATEST_JSON" 2>/dev/null)
        DISK_BEFORE=$(jq -r '.disk_usage_before' "$LATEST_JSON" 2>/dev/null)
        DISK_AFTER=$(jq -r '.disk_usage_after' "$LATEST_JSON" 2>/dev/null)
        ACTION_SUMMARY=$(jq -r '.action_summary' "$LATEST_JSON" 2>/dev/null)
        
        echo "Timestamp: $TIMESTAMP"
        echo ""
        echo "📊 STATUS:"
        echo "  Rede: $NETWORK_STATUS"
        echo "  Segurança: $SECURITY_STATUS"
        echo "  Docker: $DOCKER_STATUS"
        echo "  Dependências: $DEPENDENCIES_STATUS"
        echo "  Performance: $PERFORMANCE_STATUS"
        echo "  Limpeza: $CLEANUP_STATUS"
        echo ""
        echo "📈 METRICAS:"
        echo "  Atualizações pendentes: $UPDATES_PENDING"
        echo "  Uso de disco antes: $DISK_BEFORE"
        echo "  Uso de disco após: $DISK_AFTER"
        echo ""
        echo "📝 Resumo: $ACTION_SUMMARY"
        echo ""
    else
        echo "Nenhum relatório JSON encontrado."
    fi
    
    if [ -n "$LATEST_SUMMARY" ]; then
        echo "=== RESUMO ==="
        cat "$LATEST_SUMMARY"
        echo ""
    else
        echo "Nenhum resumo encontrado."
        echo ""
    fi
}

# Função para gerar estatísticas
show_statistics() {
    echo "=== ESTATÍSTICAS DE MANUTENÇÃO ==="
    
    # Contar número de relatórios
    REPORTS_COUNT=$(find "$LOG_DIR" -name "report_*.json" 2>/dev/null | wc -l)
    SUMMARY_COUNT=$(find "$LOG_DIR" -name "summary_*.txt" 2>/dev/null | wc -l)
    LOGS_COUNT=$(find "$LOG_DIR" -name "complete_maintenance_*.log" 2>/dev/null | wc -l)
    
    echo "Total de relatórios gerados: $REPORTS_COUNT"
    echo "Total de resumos gerados: $SUMMARY_COUNT"
    echo "Total de logs de manutenção: $LOGS_COUNT"
    echo ""
    
    # Mostrar últimos 5 relatórios
    if [ "$REPORTS_COUNT" -gt 0 ]; then
        echo " últimos 5 relatórios:"
        find "$LOG_DIR" -name "report_*.json" -printf '%T@ %p\n' 2>/dev/null | sort -n -r | head -n 5 | while read -r _ file; do
            TIMESTAMP=$(basename "$file" | sed 's/report_\(.*\)\.json/\1/')
            DATE_FORMAT=$(echo "$TIMESTAMP" | sed 's/\(....\)\(..\)\(..\)_\(..\)\(..\)\(..\)/\3\/\2\/\1 \4:\5:\6/')
            echo "  - $DATE_FORMAT"
        done
        echo ""
    fi
}

# Função para verificar pendências
show_pending_items() {
    echo "=== PENDÊNCIAS IDENTIFICADAS ==="
    
    # Procurar no último log por itens pendentes
    LATEST_LOG=$(find "$LOG_DIR" -name "complete_maintenance_*.log" -printf '%T@ %p\n' 2>/dev/null | sort -n -r | head -n1 | cut -d' ' -f2-)
    
    if [ -n "$LATEST_LOG" ] && [ -f "$LATEST_LOG" ]; then
        UPDATES_PENDING=$(grep -ci "atualizações\|upgrade\|packages" "$LATEST_LOG")
        SECURITY_ISSUES=$(grep -ci "security\|vulnerab\|senha\|permissão\|permissao" "$LATEST_LOG")
        DOCKER_ISSUES=$(grep -ci "container\|docker\|image" "$LATEST_LOG" | grep -ci "error\|issue\|problem")
        PERFORMANCE_ISSUES=$(grep -ci "alto\|alto uso\|lentid\|lento\|memory" "$LATEST_LOG")
        
        echo "  Atualizações pendentes identificadas: $UPDATES_PENDING"
        echo "  Questões de segurança identificadas: $SECURITY_ISSUES"
        echo "  Problemas com Docker identificados: $DOCKER_ISSUES"
        echo "  Questões de performance identificadas: $PERFORMANCE_ISSUES"
        echo ""
        
        # Mostrar detalhes das atualizações pendentes se houver
        if [ "$UPDATES_PENDING" -gt 0 ]; then
            echo "  Detalhes das atualizações pendentes:"
            grep -A 10 -i "atualizações\|upgrade\|packages" "$LATEST_LOG" | head -15 | sed 's/^/    /'
            echo ""
        fi
    else
        echo "  Nenhum log encontrado para análise de pendências."
        echo ""
    fi
}

# Menu principal
case "$1" in
    "latest")
        show_latest_report
        ;;
    "stats")
        show_statistics
        ;;
    "pending")
        show_pending_items
        ;;
    "all")
        show_latest_report
        show_statistics
        show_pending_items
        ;;
    *)
        echo "Uso: $0 {latest|stats|pending|all}"
        echo "  latest  - Mostra o último relatório de manutenção"
        echo "  stats   - Mostra estatísticas de manutenção"
        echo "  pending - Mostra pendências identificadas"
        echo "  all     - Mostra todas as informações acima"
        echo ""
        show_latest_report
        ;;
esac