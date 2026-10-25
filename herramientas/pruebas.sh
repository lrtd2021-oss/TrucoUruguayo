#!/usr/bin/env bash
# Ejecuta todas las pruebas GUT del proyecto sin abrir ventana.
# Uso: herramientas/pruebas.sh [opciones extra de GUT, por ejemplo -gselect=test_carta]
# La ruta de Godot se puede cambiar con la variable GODOT.
set -euo pipefail
GODOT="${GODOT:-$HOME/Herramientas/Godot/4.7.2/Godot_v4.7.2-stable_win64_console.exe}"
RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
# La primera vez (o después de agregar archivos) Godot tiene que importar el proyecto.
if [ ! -d "$RAIZ/juego/.godot" ]; then
	"$GODOT" --headless --path "$RAIZ/juego" --import >/dev/null 2>&1 || true
fi
"$GODOT" --headless --path "$RAIZ/juego" -s addons/gut/gut_cmdln.gd -gexit "$@"
