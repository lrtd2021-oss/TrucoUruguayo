class_name Reglamento
extends RefCounted
## Opciones del reglamento activo. Los valores por defecto son el reglamento
## base; las alternativas están en docs/REGLAS_TRUCO_URUGUAYO.md, punto 13.

enum Falta { PARA_GANAR, PARA_SALIR_DE_MALAS }

## Puntos para ganar el partido (30 o 40). Las malas son la mitad.
var objetivo := 30
var falta := Falta.PARA_GANAR
## Base de la flor (punto 8.2): sola, 3 por flor; flor contra flor, 3 por cada
## flor de la mesa; achicarse, 3 por cada flor del que no se achicó.
var puntos_por_flor := 3


@warning_ignore("integer_division")
func malas() -> int:
	return objetivo / 2


## Lo que vale una falta envido o una contraflor al resto con este tanteador:
## lo que le falta al que va ganando (no al que la canta).
func valor_falta(puntos: Array[int]) -> int:
	var puntero := maxi(puntos[0], puntos[1])
	if falta == Falta.PARA_SALIR_DE_MALAS and puntero < malas():
		return malas() - puntero
	return objetivo - puntero
