class_name IaBasica
extends RefCounted
## IA provisional para el prototipo (Fase 3): reglas simples, solo con la
## información de su Vista. Juega de forma legal y razonable para poder probar
## la mesa; la IA definitiva (muestreo, personalidades, señas) es de la Fase 4.

const T := Accion.Tipo


static func decidir(v: Vista, rng: RandomNumberGenerator) -> Accion:
	var m := Muestra.new(v.muestra)
	var por_tipo := {}
	for a: Accion in v.acciones_validas:
		if not por_tipo.has(a.tipo):
			por_tipo[a.tipo] = a
	if por_tipo.has(T.CANTAR_FLOR):
		return por_tipo[T.CANTAR_FLOR]
	if por_tipo.has(T.QUIERO):
		return _responder(v, m, por_tipo, rng)
	var tanto := Tantos.envido(v.mis_iniciales, m)
	if por_tipo.has(T.ENVIDO) and tanto >= 29 and rng.randf() < 0.6:
		return por_tipo[T.REAL_ENVIDO] if tanto >= 32 else por_tipo[T.ENVIDO]
	if por_tipo.has(T.TRUCO) and _fuerza(v, m) >= 2 and rng.randf() < 0.3:
		return por_tipo[T.TRUCO]
	return _elegir_carta(v, m)


static func _responder(v: Vista, m: Muestra, por_tipo: Dictionary, rng: RandomNumberGenerator) -> Accion:
	match v.canto_pendiente:
		Mano.TipoCanto.FLOR:
			return por_tipo[T.QUIERO]
		Mano.TipoCanto.ENVIDO:
			var tanto := Tantos.envido(v.mis_iniciales, m)
			var es_falta := _ultimo_canto(v) == "falta envido"
			if tanto >= (31 if es_falta else 27):
				return por_tipo[T.QUIERO]
			return por_tipo[T.NO_QUIERO]
		_:
			var fuerza := _fuerza(v, m)
			if fuerza >= 3 and por_tipo.has(T.TRUCO) and rng.randf() < 0.3:
				return por_tipo[T.TRUCO]
			if fuerza >= 1 or rng.randf() < 0.25:
				return por_tipo[T.QUIERO]
			return por_tipo[T.NO_QUIERO]


## Cuántas cartas fuertes (matas o piezas) le quedan, más las bazas ganadas.
static func _fuerza(v: Vista, m: Muestra) -> int:
	var f := 0
	for c: int in v.mis_cartas:
		if m.poder(c) >= 11:
			f += 1
	return f + v.resultados.count(Mano.equipo(v.jugador))


## Si el compañero va ganando la baza, tira la más baja; si no, la más baja que
## mata; si no puede matar, la más baja.
static func _elegir_carta(v: Vista, m: Muestra) -> Accion:
	var cartas: Array[Accion] = v.acciones_validas.filter(
		func(a: Accion) -> bool: return a.tipo == T.JUGAR_CARTA)
	cartas.sort_custom(func(a: Accion, b: Accion) -> bool: return m.poder(a.carta) < m.poder(b.carta))
	var mesa := v.mesa_actual()
	var mejor := -1
	var dueno := -1
	for j: int in mesa:
		var c: int = mesa[j]
		if m.poder(c) > mejor:
			mejor = m.poder(c)
			dueno = j
	if dueno >= 0 and Mano.equipo(dueno) == Mano.equipo(v.jugador):
		return cartas[0]
	for a: Accion in cartas:
		if m.poder(a.carta) > mejor:
			return a
	return cartas[0]


static func _ultimo_canto(v: Vista) -> String:
	for i: int in range(v.historial.size() - 1, -1, -1):
		var e: Dictionary = v.historial[i]
		if e.tipo == "canto":
			return e.canto
	return ""
