class_name Carta
extends RefCounted
## Identidad de una carta de la baraja española de 40.
##
## Una carta es un entero de 0 a 39: palo * 10 + índice, con los índices 0 a 9
## para los números 1, 2, 3, 4, 5, 6, 7, 10, 11 y 12. Lo que depende de la
## muestra (piezas, poder, valor de tanto) vive en Muestra, nunca acá.

enum Palo { OROS, COPAS, ESPADAS, BASTOS }

const TOTAL := 40
const NUMEROS: Array[int] = [1, 2, 3, 4, 5, 6, 7, 10, 11, 12]
const LETRAS_PALO := "OCEB"


static func crear(numero: int, palo: int) -> int:
	assert(numero in NUMEROS and palo >= 0 and palo < 4, "carta inexistente")
	return palo * 10 + NUMEROS.find(numero)


@warning_ignore("integer_division")
static func palo(c: int) -> int:
	return c / 10


static func numero(c: int) -> int:
	return NUMEROS[c % 10]


## Notación del reglamento: número seguido de la letra del palo ("1E", "11O").
static func texto(c: int) -> String:
	return "%d%s" % [numero(c), LETRAS_PALO[palo(c)]]


static func desde_texto(t: String) -> int:
	return crear(t.left(-1).to_int(), LETRAS_PALO.find(t.right(1)))


static func lista(textos: Array[String]) -> Array[int]:
	var r: Array[int] = []
	for t: String in textos:
		r.append(desde_texto(t))
	return r


static func mazo() -> Array[int]:
	var r: Array[int] = []
	for c: int in TOTAL:
		r.append(c)
	return r


## Fisher-Yates con un generador propio. No se usa Array.shuffle() porque
## depende del generador global y rompería la reproducibilidad por semilla.
static func mezclar(cartas: Array[int], rng: RandomNumberGenerator) -> void:
	for i: int in range(cartas.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var t := cartas[i]
		cartas[i] = cartas[j]
		cartas[j] = t
