#!/usr/bin/env bash
# Ejecuta todas las pruebas GUT del proyecto sin abrir ventana.
# Uso: herramientas/pruebas.sh [opciones extra de GUT, por ejemplo -gselect=test_carta]
# La ruta de Godot se puede cambiar con la variable GODOT.
#
# Devuelve 0 solo si todas las pruebas pasan y no hubo errores de script. GUT
# por sí solo devuelve 0 aunque un archivo de pruebas no compile (y entonces
# sus pruebas ni se ejecutan), así que acá se revisa la salida.
set -euo pipefail
GODOT="${GODOT:-$HOME/Herramientas/Godot/4.7.2/Godot_v4.7.2-stable_win64_console.exe}"
RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
# La primera vez (o después de agregar archivos) Godot tiene que importar el proyecto.
if [ ! -d "$RAIZ/juego/.godot" ]; then
	"$GODOT" --headless --path "$RAIZ/juego" --import >/dev/null 2>&1 || true
fi
salida="$(mktemp)"
trap 'rm -f "$salida"' EXIT
set +e
"$GODOT" --headless --path "$RAIZ/juego" -s addons/gut/gut_cmdln.gd -gexit "$@" 2>&1 | tee "$salida"
codigo=${PIPESTATUS[0]}
set -e
if grep -q -E "SCRIPT ERROR|Parse Error|Failed to load script" "$salida"; then
	echo "FALLO: hubo errores de script (ver arriba)." >&2
	exit 1
fi
exit "$codigo"
