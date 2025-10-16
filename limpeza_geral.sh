#!/bin/bash
echo "--- Docker System Prune Started: $(date) ---"

# This command permanently removes stopped containers, unused networks, and dangling images.
docker system prune -af

echo "--- Docker System Prune Finished: $(date) ---"
