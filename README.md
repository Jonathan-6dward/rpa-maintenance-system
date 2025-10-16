# Guardião RPA - Automação de Manutenção de Ambiente

Um sistema automatizado de auditoria, otimização e manutenção para ambientes de desenvolvimento Linux, agora mais seguro e portável.

## 📖 Descrição

Este projeto implementa um "Robô" para automação de tarefas de manutenção (RPA) em ambientes de desenvolvimento baseados em Linux. O sistema realiza auditorias completas de rede, segurança, contêineres Docker, dependências e performance, além de executar limpezas e atualizações de forma automatizada.

Após a recente refatoração, os scripts são totalmente portáteis (funcionam no diretório home de qualquer usuário) e mais seguros (não contêm mais senhas fixas no código).

## ✨ Funcionalidades Principais

- **Auditoria Completa:** Scripts para varredura de rede, segurança, permissões e performance.
- **Limpeza e Otimização:** Limpeza de cache, remoção de pacotes órfãos e otimização de contêineres Docker.
- **Atualização Segura:** Script para atualização do sistema (compatível com Arch e Debian).
- **Agendamento Automático:** Scripts de setup para configurar tarefas de manutenção recorrentes via Cron.
- **Relatórios:** Geração de logs detalhados para cada operação.

## 🚀 Instalação e Configuração

Os scripts de setup configuram aliases e tarefas agendadas (cron jobs) para automatizar a manutenção. Escolha o script correspondente ao seu sistema operacional:

-   **Para Arch Linux e derivados (Manjaro, Garuda):**
    ```bash
    bash /home/deadsec/Guardiao-RPA/setup_cron_arch.sh
    ```
-   **Para Debian e derivados (Ubuntu, Mint):**
    ```bash
    bash /home/deadsec/Guardiao-RPA/setup_cron.sh
    ```

Após a execução, reinicie seu terminal ou execute `source ~/.bashrc` para carregar os novos aliases.

## 🛠️ Como Usar

Após a configuração, você pode usar os seguintes aliases no seu terminal:

| Alias                 | Descrição                                         | Script Correspondente         |
| --------------------- | --------------------------------------------------- | ----------------------------- |
| `guardiao-audit`      | Realiza uma auditoria completa do sistema.          | `auditoria_sistema.sh`        |
| `guardiao-clean`      | Executa uma limpeza de contêineres e pacotes.       | `maintenance.sh`              |
| `guardiao-full`       | Roda uma sequência de manutenção completa.          | `complete_maintenance.sh`     |
| `guardiao-dockerclean`| Remove contêineres, redes e imagens não usadas.     | `docker system prune -af`     |
| `guardiao-report`     | Visualiza o último relatório de manutenção.         | `report_viewer.sh`            |
| `guardiao-update`     | Executa uma atualização segura do sistema (pede senha). | `atualizacao_segura.sh`       |
| `guardiao-backup`     | Realiza backup de arquivos de configuração.         | `backup_configuracoes.sh`     |

## 🗺️ Roadmap e Futuras Atualizações

Este projeto está em desenvolvimento contínuo. Os próximos passos planejados incluem:

-   [ ] **Melhorar Compatibilidade Linux:** Unificar os scripts para detectar e rodar em qualquer distribuição moderna (Debian, Ubuntu, Arch, Fedora) de forma transparente.
-   [ ] **Suporte para Windows 11:** Criar uma versão dos scripts em PowerShell para oferecer as mesmas funcionalidades de automação no ambiente Windows, possivelmente utilizando o WSL.
-   [ ] **Novas Features de Cibersegurança:**
    -   Implementar um monitor de integridade de arquivos (FIM).
    -   Adicionar verificação de vulnerabilidades em dependências de projetos (ex: `npm audit`, `pip-audit`).
    -   Integrar com APIs de inteligência de ameaças para verificar IPs e domínios suspeitos.
-   [ ] **Sistema de Releases:** Adotar um versionamento semântico (v1.0.0, v1.1.0) e usar as "Releases" do GitHub para documentar as mudanças em cada nova versão.

## 🤝 Contribuição

Sinta-se à vontade para abrir *issues* e *pull requests* para melhorar o projeto.

## 📄 Licença

Este projeto está licenciado sob a licença MIT.
