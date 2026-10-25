class_name IaAleatoria
extends RefCounted
## IA mínima: elige al azar entre las acciones válidas. Sirve para comprobar
## que el motor no se traba con decisiones arbitrarias (R-67), no para jugar.


static func decidir(v: Vista, rng: RandomNumberGenerator) -> Accion:
	assert(not v.acciones_validas.is_empty(), "la IA no tiene acciones para elegir")
	return v.acciones_validas[rng.randi_range(0, v.acciones_validas.size() - 1)]
