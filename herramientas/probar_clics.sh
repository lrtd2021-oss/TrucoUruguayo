#!/usr/bin/env bash
# Comprobación de punta a punta con ventana real: abre el juego, envía clics de
# ratón a una carta y a un botón, y sale con 0 si llegaron al motor (1 si no).
# Uso: herramientas/probar_clics.sh [resolución, por ejemplo 1280x720]
set -euo pipefail
GODOT="${GODOT:-$HOME/Herramientas/Godot/4.7.2/Godot_v4.7.2-stable_win64_console.exe}"
RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
"$GODOT" --path "$RAIZ/juego" -- --semilla=21 --velocidad=4 --resolucion="${1:-1920x1080}" --probar-clics
