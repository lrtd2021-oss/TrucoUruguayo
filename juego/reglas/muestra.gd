class_name Muestra
extends RefCounted
## Lo que la carta dada vuelta impone a la mano: piezas, alcahuete, jerarquía
## y valores de tanto. Reglamento, puntos 3, 4 y 5.1.

enum Grupo { COMUN, NEGRA, CHICA, MATA, PIEZA }

## Números de las piezas en su orden (1.º a 5.º) y su valor de tanto.
const NUMEROS_PIEZA: Array[int] = [2, 4, 5, 11, 10]
const VALOR_PIEZA: Array[int] = [30, 29, 28, 27, 27]

## Poder en el truco de las cartas que no son pieza ni mata, por número.
const PODER_COMUN: Dictionary[int, int] = {
	3: 10, 2: 9, 1: 8, 12: 7, 11: 6, 10: 5, 7: 4, 6: 3, 5: 2, 4: 1,
}

var carta: int
var palo: int
## Si la muestra es una pieza, el rey de su palo (alcahuete) toma su lugar.
var alcahuete_activo: bool
## Orden (1 a 5) de la pieza que reemplaza el alcahuete, 0 si no está activo.
var pieza_reemplazada: int


func _init(carta_muestra: int) -> void:
	carta = carta_muestra
	palo = Carta.palo(carta_muestra)
	pieza_reemplazada = NUMEROS_PIEZA.find(Carta.numero(carta_muestra)) + 1
	alcahuete_activo = pieza_reemplazada > 0


## 0 si la carta no es pieza; si no, su orden de 1 (el dos) a 5 (la perica).
func orden_pieza(c: int) -> int:
	if Carta.palo(c) != palo or c == carta:
		return 0
	var n := Carta.numero(c)
	if n == 12:
		return pieza_reemplazada
	return NUMEROS_PIEZA.find(n) + 1


## Poder en el truco: mayor gana, igual empata. Única fuente de la jerarquía.
## Piezas 19 a 15, matas 14 a 11 y el resto según PODER_COMUN (10 a 1).
func poder(c: int) -> int:
	var k := orden_pieza(c)
	if k > 0:
		return 20 - k
	var n := Carta.numero(c)
	var p := Carta.palo(c)
	if n == 1 and p == Carta.Palo.ESPADAS:
		return 14
	if n == 1 and p == Carta.Palo.BASTOS:
		return 13
	if n == 7 and p == Carta.Palo.ESPADAS:
		return 12
	if n == 7 and p == Carta.Palo.OROS:
		return 11
	return PODER_COMUN[n]


func grupo(c: int) -> Grupo:
	var pd := poder(c)
	if pd >= 15:
		return Grupo.PIEZA
	if pd >= 11:
		return Grupo.MATA
	if pd >= 8:
		return Grupo.CHICA
	if pd >= 5:
		return Grupo.NEGRA
	return Grupo.COMUN


## Valor para envido y flor: piezas 30 a 27, del 1 al 7 su número, figuras 0.
func valor_tanto(c: int) -> int:
	var k := orden_pieza(c)
	if k > 0:
		return VALOR_PIEZA[k - 1]
	var n := Carta.numero(c)
	return n if n <= 7 else 0
