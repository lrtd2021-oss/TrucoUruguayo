#!/usr/bin/env bash
# Mide la fuerza de la IA: 1000 partidos contra la IA aleatoria y 200 contra la
# básica, con repartos espejados. Tarda varios minutos.
# Igual que pruebas.sh, un error de script cuenta como fallo.
set -euo pipefail
GODOT="${GODOT:-$HOME/Herramientas/Godot/4.7.2/Godot_v4.7.2-stable_win64_console.exe}"
RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
salida="$(mktemp)"
trap 'rm -f "$salida"' EXIT
set +e
"$GODOT" --headless --path "$RAIZ/juego" -s addons/gut/gut_cmdln.gd -gexit -gconfig= \
	-gdir=res://mediciones -gprefix=medir_ -glog=1 "$@" 2>&1 | tee "$salida"
codigo=${PIPESTATUS[0]}
set -e
if grep -q -E "SCRIPT ERROR|Parse Error|Failed to load script" "$salida"; then
	echo "FALLO: hubo errores de script (ver arriba)." >&2
	exit 1
fi
if ! grep -q "contra la IA aleatoria" "$salida"; then
	echo "FALLO: la medición no llegó a ejecutarse." >&2
	exit 1
fi
exit "$codigo"
