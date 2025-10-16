#!/bin/bash
# Script para limpar logs antigos
find $HOME/Logs -name "*.log" -mtime +30 -delete
find $HOME/Logs -name "*.txt" -mtime +30 -delete
find $HOME/Logs -name "*.json" -mtime +60 -delete
