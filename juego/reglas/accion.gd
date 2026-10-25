class_name Accion
extends RefCounted
## Una decisión de un jugador. La interfaz y la IA solo eligen entre las que
## devuelve Mano.acciones_validas(); Mano.aplicar() rechaza cualquier otra.
##
## Las respuestas usan nombres genéricos: frente a una flor, QUIERO es «con flor
## quiero» y NO_QUIERO es «con flor me achico». TRUCO también sirve para subir
## (retruco, vale cuatro): el nivel lo determina el estado de la mano.

enum Tipo {
	JUGAR_CARTA,
	CANTAR_FLOR, CONTRAFLOR_AL_RESTO, CON_FLOR_ME_ACHICO,
	ENVIDO, REAL_ENVIDO, FALTA_ENVIDO,
	TRUCO,
	QUIERO, NO_QUIERO,
	IR_AL_MAZO,
}

var tipo: Tipo
var jugador: int
var carta: int


func _init(t: Tipo, j: int, c: int = -1) -> void:
	tipo = t
	jugador = j
	carta = c


func es_igual(otra: Accion) -> bool:
	return tipo == otra.tipo and jugador == otra.jugador and carta == otra.carta


func _to_string() -> String:
	var extra := " " + Carta.texto(carta) if carta >= 0 else ""
	return "J%d %s%s" % [jugador, Tipo.keys()[tipo], extra]
