class_name RegistroSenas
extends RefCounted
## Las señas hechas en una mano y quién vio cada una. Es información privada:
## cada jugador recibe en su Vista solo las que hizo o vio.
##
## Regla de observación, igual para todos (reglamento, punto 11; D-24):
## el compañero ve siempre la seña, porque quien la hace espera a que lo mire;
## cada rival la ve con probabilidad atención del rival x (1 - disimulo de
## quien la hace).

var hechas: Array[Dictionary] = []


## Registra una seña y sortea quién la vio. atencion y disimulo son los
## valores de cada asiento (0 a 1).
func hacer(emisor: int, sena_id: String, atencion: Array[float], disimulo: Array[float],
		rng: RandomNumberGenerator) -> Dictionary:
	var vieron: Array[int] = []
	for j: int in Mano.JUGADORES:
		if j == emisor:
			continue
		if Mano.equipo(j) == Mano.equipo(emisor) or rng.randf() < atencion[j] * (1.0 - disimulo[emisor]):
			vieron.append(j)
	var s := {"emisor": emisor, "sena": sena_id, "vieron": vieron}
	hechas.append(s)
	return s


## Las señas que conoce un jugador: las propias y las que vio.
func conocidas_por(j: int) -> Array[Dictionary]:
	var r: Array[Dictionary] = []
	for s: Dictionary in hechas:
		if s.emisor == j or j in s.vieron:
			r.append(s.duplicate(true))
	return r
