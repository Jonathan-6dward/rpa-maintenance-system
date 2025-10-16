# RPA de Manutenção de Ambiente de Desenvolvimento

Um sistema automatizado de auditoria, otimização e manutenção para ambientes de desenvolvimento Linux criado por Jonathan Edward.

## Descrição

Este projeto implementa um Robô de Processos Robóticos (RPA) para automação de tarefas de manutenção em ambientes de desenvolvimento Linux. O sistema realiza auditorias completas de rede, segurança, containers Docker, dependências e performance, além de executar limpezas e atualizações automáticas.

## Funcionalidades

- Auditoria de rede e conectividade
- Verificação de segurança
- Gestão de containers Docker
- Atualização e limpeza de sistema
- Relatórios detalhados em JSON
- Tarefas agendadas automáticas

## Instalação

Execute o script setup_cron_arch.sh no seu ambiente de desenvolvimento para configurar as tarefas agendadas.

## Scripts

- `system_audit.sh`: Realiza auditoria completa do sistema
- `maintenance.sh`: Executa limpeza de containers e pacotes
- `complete_maintenance.sh`: Combina auditoria e limpeza em uma rotina completa
- `report_viewer.sh`: Visualiza e analisa relatórios de manutenção
- `setup_cron_arch.sh`: Configura tarefas agendadas (para Arch Linux e derivados)

## Como Usar

Após a instalação com setup_cron_arch.sh, os scripts estarão disponíveis para uso manual ou agendado:

- `syscheck`: Auditoria do sistema
- `cleanenv`: Limpeza do ambiente
- `fullmaint`: Manutenção completa
- `dockerclean`: Limpeza de containers Docker
- `netscan`: Verificação de portas abertas
- `sysreport`: Visualização de relatórios
- `sysupdate`: Atualização segura do sistema

## Contribuição

Sinta-se à vontade para abrir issues e pull requests para melhorar o projeto.

## Licença

Este projeto está licenciado sob a licença MIT.