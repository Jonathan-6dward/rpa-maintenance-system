#!/bin/bash
echo "--- System Audit Started: $(date) ---"
echo ""

echo "--- DISK SPACE ---"
df -h $HOME
echo ""

echo "--- DIRS WITH 777 PERMS ---"
find $HOME -maxdepth 4 -type d -perm 777 -print -o -name ".git" -prune -o -name "node_modules" -prune -o -name ".cache" -prune
echo ""

echo "--- FILES WITH 666 PERMS ---"
find $HOME -maxdepth 4 -type f -perm 666 -print -o -name ".git" -prune -o -name "node_modules" -prune -o -name ".cache" -prune
echo ""

echo "--- BROKEN SYMLINKS ---"
find $HOME -maxdepth 4 -type l ! -exec test -e {} \; -print -o -name ".git" -prune -o -name "node_modules" -prune -o -name ".cache" -prune
echo ""

echo "--- PATH CHECK ---"
(IFS=:; for dir in $PATH; do if [ ! -d "$dir" ]; then echo "Invalid PATH entry: $dir"; fi; done)
echo ""

echo "--- Audit Complete: $(date) ---"
