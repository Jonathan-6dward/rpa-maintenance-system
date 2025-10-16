# Guia de Integração: Guardião RPA + Obsidian

Este guia explica como executar os scripts de manutenção do Guardião RPA diretamente da sua interface do Obsidian, criando um painel de controle personalizado.

## Pré-requisito: Plugin `Obsidian Shell Commands`

A integração é feita através de um plugin da comunidade. Se você ainda não o tem, siga os passos:

1.  Abra o Obsidian.
2.  Vá em `Configurações` ⚙️.
3.  Clique em `Plugins da comunidade`.
4.  Clique em `Explorar` e busque por **"Obsidian Shell Commands"**.
5.  Clique em `Instalar` e, depois de instalar, clique em `Habilitar`.

## Passo 1: Configurando os Comandos no Plugin

Agora, vamos dizer ao plugin quais scripts ele deve conhecer.

1.  Ainda nas `Configurações` do Obsidian, role para baixo até encontrar a seção `Shell Commands`.
2.  Você verá uma área para adicionar novos comandos. Crie um para cada script que deseja usar. Abaixo estão os exemplos prontos para você copiar:

---

**Comando 1: Auditoria do Sistema**
-   **Nome do Comando:** `Guardião: Executar Auditoria do Sistema`
-   **Comando Shell:** `bash /home/deadsec/Guardiao-RPA/auditoria_sistema.sh`

**Comando 2: Limpeza do Ambiente**
-   **Nome do Comando:** `Guardião: Executar Limpeza do Ambiente`
-   **Comando Shell:** `bash /home/deadsec/Guardiao-RPA/maintenance.sh`

**Comando 3: Manutenção Completa**
-   **Nome do Comando:** `Guardião: Executar Manutenção Completa`
-   **Comando Shell:** `bash /home/deadsec/Guardiao-RPA/complete_maintenance.sh`

**Comando 4: Atualização Segura do Sistema**
-   **Nome do Comando:** `Guardião: Executar Atualização Segura`
-   **Comando Shell:** `sudo bash /home/deadsec/Guardiao-RPA/atualizacao_segura.sh`
    -   *Nota: Comandos com `sudo` podem pedir sua senha em uma janela de terminal que se abrirá.*

**Comando 5: Visualizar Último Relatório**
-   **Nome do Comando:** `Guardião: Visualizar Último Relatório`
-   **Comando Shell:** `bash /home/deadsec/Guardiao-RPA/report_viewer.sh`

**Comando 6: Backup de Configurações**
-   **Nome do Comando:** `Guardião: Executar Backup de Configurações`
-   **Comando Shell:** `bash /home/deadsec/Guardiao-RPA/backup_configuracoes.sh`

---

## Passo 2: Criando o Painel de Controle

Agora vem a parte divertida. Crie uma nova nota no Obsidian, que será seu painel.

1.  Crie uma nota chamada, por exemplo, `Painel Guardião RPA`.
2.  Para executar um comando, você pode usar a paleta de comandos do Obsidian (`Ctrl+P` ou `Cmd+P`) e digitar o nome do comando que você deu (ex: "Guardião: Executar Auditoria").

### Criando Botões (Avançado)

Para uma interface mais visual, você pode usar um outro plugin chamado `Buttons` em conjunto com o `Obsidian Shell Commands`. Depois de instalar o plugin `Buttons`:

1.  Crie um botão que chama um comando da paleta. O formato é o seguinte:

    ```button
    name Executar Auditoria
    type command
    action Obsidian Shell Commands: Guardião: Executar Auditoria do Sistema
    ```

2.  Você pode criar um botão para cada comando. Aqui está um exemplo de painel que você pode colar na sua nota:

    ```markdown
    # Painel de Controle - Guardião RPA

    ## Auditoria e Verificação
    ```button
    name 👁️ Executar Auditoria do Sistema
    type command
    action Obsidian Shell Commands: Guardião: Executar Auditoria do Sistema
    ```
    ```button
    name 📊 Visualizar Último Relatório
    type command
    action Obsidian Shell Commands: Guardião: Visualizar Último Relatório
    ```

    ## Manutenção e Limpeza
    ```button
    name 🧹 Executar Limpeza do Ambiente
    type command
    action Obsidian Shell Commands: Guardião: Executar Limpeza do Ambiente
    ```
    ```button
    name 🚀 Executar Manutenção Completa
    type command
    action Obsidian Shell Commands: Guardião: Executar Manutenção Completa
    ```

    ## Ações Críticas (Exigem Senha)
    ```button
    name ⬆️ Executar Atualização Segura
    type command
    action Obsidian Shell Commands: Guardião: Executar Atualização Segura
    ```
    ```

Com isso, você terá um painel funcional dentro do seu cofre do Obsidian para gerenciar seu sistema.
