class_name Escenario
extends RefCounted
## Construye manos con cartas elegidas, para las pruebas y el tutorial.
## Las acciones previas se aplican con Mano.aplicar(), así que no se puede
## armar un escenario que el reglamento no permita.


## manos: un texto por jugador, en orden de juego desde el asiento 0
## (por ejemplo "4O 3B 6C"). El repartidor por defecto es el 3, así el
## asiento 0 es mano.
static func mano(muestra: String, manos: Array[String], repartidor := 3,
		puntos: Array[int] = [0, 0], reg: Reglamento = null) -> Mano:
	var cartas: Array = []
	for t: String in manos:
		var nombres: Array[String] = []
		nombres.assign(t.split(" ", false))
		cartas.append(Carta.lista(nombres))
	return Mano.new(reg if reg else Reglamento.new(), Carta.desde_texto(muestra), cartas, repartidor, puntos)


## Arma la mano y aplica las acciones en orden. Devuelve {mano, error}: si
## alguna acción es ilegal, mano es null y error explica cuál falló.
static func construir(muestra: String, manos: Array[String], acciones: Array[Accion],
		repartidor := 3, puntos: Array[int] = [0, 0], reg: Reglamento = null) -> Dictionary:
	var m := mano(muestra, manos, repartidor, puntos, reg)
	for i: int in acciones.size():
		var r := m.aplicar(acciones[i])
		if not r.ok:
			return {"mano": null, "error": "acción %d (%s): %s" % [i, acciones[i], r.error]}
	return {"mano": m, "error": ""}
