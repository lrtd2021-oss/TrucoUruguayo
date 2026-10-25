class_name IaMuestreo
extends RefCounted
## IA de la Fase 4. Decide con su Vista, sin ver cartas ocultas:
##   1. arma hipótesis de las cartas ajenas (Muestreador);
##   2. estima con ellas la probabilidad de ganar la mano (Simulador), el
##      envido y la flor;
##   3. compara lo que gana y lo que arriesga, ajustado por su personalidad.
## Los tantos, el valor de los cantos y quién gana cada baza salen del motor
## (Tantos, Mano), no de una versión propia.

const T := Accion.Tipo

## Conteos por personaje para medir que las personalidades se diferencian
## (tarea 4.2). Solo se usan en pruebas y mediciones.
static var estadisticas := {}


## Devuelve la acción elegida.
static func decidir(v: Vista, perfil: PerfilIA, senas: PerfilSenas, rng: RandomNumberGenerator) -> Accion:
	return decidir_con_detalle(v, perfil, senas, rng).accion


## Devuelve {accion, p_mano, p_envido, p_flor, motivo}. Las probabilidades son
## estimaciones por muestreo (-1 si no se calcularon).
static func decidir_con_detalle(v: Vista, perfil: PerfilIA, senas: PerfilSenas, rng: RandomNumberGenerator) -> Dictionary:
	var por_tipo := {}
	for a: Accion in v.acciones_validas:
		if not por_tipo.has(a.tipo):
			por_tipo[a.tipo] = a
	var r := {"accion": null, "p_mano": -1.0, "p_envido": -1.0, "p_flor": -1.0, "motivo": ""}
	if v.acciones_validas.is_empty():
		r.motivo = "no le toca"
		return r
	if v.acciones_validas.size() == 1:
		r.accion = v.acciones_validas[0]
		r.motivo = "única acción posible"
		return r
	if perfil.errores > 0.0 and rng.randf() < perfil.errores:
		var opciones := v.acciones_validas.filter(func(a: Accion) -> bool: return a.tipo != T.IR_AL_MAZO)
		r.accion = opciones[rng.randi_range(0, opciones.size() - 1)]
		r.motivo = "error humano"
		return r
	var mu := Muestreador.new(v, senas, perfil.usar_inferencias)
	var hipotesis: Array = []
	for i: int in perfil.muestras:
		hipotesis.append(mu.muestrear(rng))
	if por_tipo.has(T.CANTAR_FLOR):
		_declarar_flor(r, v, mu, hipotesis, perfil, por_tipo)
	elif por_tipo.has(T.QUIERO):
		_responder(r, v, mu, hipotesis, perfil, por_tipo, rng)
	else:
		_turno(r, v, mu, hipotesis, perfil, por_tipo, rng)
	return r


# --- Estimaciones ------------------------------------------------------------

## Probabilidad de que la pareja gane la mano jugando la carta dada (-1: la que
## elija la política) desde el estado actual.
static func p_mano(v: Vista, mu: Muestreador, hipotesis: Array, carta := -1) -> float:
	var mesa: Array[int] = [-1, -1, -1, -1]
	var en_mesa := v.mesa_actual()
	for j: int in en_mesa:
		mesa[j] = en_mesa[j]
	var ganadas := 0
	for h: Array in hipotesis:
		var manos: Array[Array] = []
		manos.assign(h)
		manos[v.jugador] = v.mis_cartas.duplicate()
		var g := Simulador.jugar(manos, mesa, v.abre, v.turno, v.resultados, v.jugador_mano, mu.muestra, carta)
		if g == Mano.equipo(v.jugador):
			ganadas += 1
	return float(ganadas) / maxf(1.0, hipotesis.size())


static func p_envido(v: Vista, mu: Muestreador, hipotesis: Array) -> float:
	var ganadas := 0
	for h: Array in hipotesis:
		var manos: Array[Array] = []
		manos.assign(h)
		var tantos: Array[int] = []
		for j: int in Mano.JUGADORES:
			tantos.append(Tantos.envido(mu.iniciales_hipoteticas(manos, j), mu.muestra))
		if Mano.equipo(Mano.ganador_tantos(tantos, v.jugador_mano)) == Mano.equipo(v.jugador):
			ganadas += 1
	return float(ganadas) / maxf(1.0, hipotesis.size())


## Probabilidad de ganar flor contra flor, entre los que tienen o declararon flor.
static func p_flor(v: Vista, mu: Muestreador, hipotesis: Array) -> float:
	var ganadas := 0
	for h: Array in hipotesis:
		var manos: Array[Array] = []
		manos.assign(h)
		var flores: Array[int] = []
		for j: int in Mano.JUGADORES:
			var completa := mu.iniciales_hipoteticas(manos, j)
			var tiene := (j == v.jugador or mu.flor[j] == 1) and Tantos.tiene_flor(completa, mu.muestra)
			flores.append(Tantos.valor_flor(completa, mu.muestra) if tiene else -1)
		var g := Mano.ganador_tantos(flores, v.jugador_mano)
		if g >= 0 and Mano.equipo(g) == Mano.equipo(v.jugador):
			ganadas += 1
	return float(ganadas) / maxf(1.0, hipotesis.size())


# --- Decisiones --------------------------------------------------------------

## Al declarar con flor rival en la mesa: achicarse entrega 3 por cada flor
## rival; flor contra flor se juega 3 por cada flor de la mesa (reglamento, 8.2).
static func _declarar_flor(r: Dictionary, v: Vista, mu: Muestreador, hipotesis: Array, perfil: PerfilIA, por_tipo: Dictionary) -> void:
	r.accion = por_tipo[T.CANTAR_FLOR]
	r.motivo = "la flor se canta siempre"
	if por_tipo.has(T.CONTRAFLOR_AL_RESTO):
		r.p_flor = p_flor(v, mu, hipotesis)
		var p: float = r.p_flor
		var flores := _flores(v)
		var mesa := flores[0] + flores[1] + 1  # más la propia, que se está declarando
		if p > 0.85 - 0.1 * perfil.agresividad:
			_elegir(r, por_tipo[T.CONTRAFLOR_AL_RESTO], "mi flor probablemente es la mejor")
		elif (2.0 * p - 1.0) * 3 * mesa < -3 * flores[1] - perfil.prudencia:
			_elegir(r, por_tipo[T.CON_FLOR_ME_ACHICO], "mi flor probablemente pierde")


static func _flores_declaradas(v: Vista) -> Array[int]:
	var r: Array[int] = []
	for e: Dictionary in v.historial:
		if e.tipo == "flor":
			r.append(e.jugador)
	return r


## Flores declaradas hasta ahora: [de mi pareja, de la otra pareja].
static func _flores(v: Vista) -> Array[int]:
	var r: Array[int] = [0, 0]
	for e: Dictionary in v.historial:
		if e.tipo == "flor":
			r[0 if Mano.equipo(e.jugador) == Mano.equipo(v.jugador) else 1] += 1
	return r


static func _responder(r: Dictionary, v: Vista, mu: Muestreador, hipotesis: Array, perfil: PerfilIA,
		por_tipo: Dictionary, rng: RandomNumberGenerator) -> void:
	match v.canto_pendiente:
		Mano.TipoCanto.FLOR:
			# No querer es achicarse: la otra pareja suma 3 por cada flor suya.
			r.p_flor = p_flor(v, mu, hipotesis)
			var p: float = r.p_flor
			var flores := _flores(v)
			var en_juego := 3 * (flores[0] + flores[1]) if v.nivel_canto == Mano.NivelFlor.CONTRA else v.valor_falta
			var quiero := (2.0 * p - 1.0) * en_juego > -3 * flores[1] - perfil.prudencia
			if por_tipo.has(T.CONTRAFLOR_AL_RESTO) and p > 0.85 - 0.1 * perfil.agresividad:
				_elegir(r, por_tipo[T.CONTRAFLOR_AL_RESTO], "mi flor probablemente es la mejor")
			else:
				_elegir(r, por_tipo[T.QUIERO if quiero else T.NO_QUIERO], "comparo lo que gano y lo que arriesgo con la flor")
		Mano.TipoCanto.ENVIDO:
			_responder_envido(r, v, mu, hipotesis, perfil, por_tipo)
		_:
			_responder_truco(r, v, mu, hipotesis, perfil, por_tipo, rng)


static func _responder_envido(r: Dictionary, v: Vista, mu: Muestreador, hipotesis: Array, perfil: PerfilIA, por_tipo: Dictionary) -> void:
	r.p_envido = p_envido(v, mu, hipotesis)
	var p: float = r.p_envido
	var si := Mano.valor_envido(v.secuencia_envido, v.valor_falta)
	var no := Mano.valor_envido_rechazado(v.secuencia_envido, v.valor_falta)
	var margen := 0.6 * perfil.prudencia
	# Querer conviene si lo que se espera ganar supera lo que se pierde al no querer.
	var conviene := (2.0 * p - 1.0) * si > -no + margen
	if p > 0.85 - 0.1 * perfil.agresividad:
		for subida: int in [T.REAL_ENVIDO, T.ENVIDO, T.FALTA_ENVIDO]:
			if por_tipo.has(subida) and (subida != T.FALTA_ENVIDO or p > 0.92):
				_elegir(r, por_tipo[subida], "mi tanto probablemente gana: subo")
				return
	_elegir(r, por_tipo[T.QUIERO if conviene else T.NO_QUIERO], "comparo lo que gano y lo que arriesgo en el envido")


static func _responder_truco(r: Dictionary, v: Vista, mu: Muestreador, hipotesis: Array, perfil: PerfilIA,
		por_tipo: Dictionary, rng: RandomNumberGenerator) -> void:
	if por_tipo.has(T.ENVIDO):
		# El envido está primero: si el tanto es bueno, se canta antes de responder.
		r.p_envido = p_envido(v, mu, hipotesis)
		if r.p_envido > 0.7 - 0.1 * perfil.agresividad:
			_elegir(r, por_tipo[T.ENVIDO], "el envido está primero y mi tanto es bueno")
			_contar(perfil, "envido_cantado")
			return
	r.p_mano = p_mano(v, mu, hipotesis)
	var p: float = r.p_mano
	var n := v.nivel_canto
	# Cuanto más alto el canto, más respeto: quien sube suele tener con qué.
	var margen := 0.4 * perfil.prudencia + 0.6 * (n - 2)
	# No querer en la primera baza termina la mano: una flor del compañero que
	# todavía no declaró (conocida por seña) se perdería (D-20).
	var flor_en_riesgo := 0
	if v.baza == 0:
		for j: int in Mano.JUGADORES:
			if j != v.jugador and Mano.equipo(j) == Mano.equipo(v.jugador) and mu.flor[j] == 1 \
					and mu.jugadas[j].is_empty() and not _flores_declaradas(v).has(j):
				flor_en_riesgo += 3
	var conviene := (2.0 * p - 1.0) * n > -(n - 1) - flor_en_riesgo + margen
	if por_tipo.has(T.TRUCO) and (p > 0.8 - 0.12 * perfil.agresividad or (p < 0.3 and rng.randf() < perfil.farol * 0.5)):
		_elegir(r, por_tipo[T.TRUCO], "subo el truco")
		_contar(perfil, "truco_cantado")
		if p < 0.3:
			_contar(perfil, "truco_farol")
		return
	_elegir(r, por_tipo[T.QUIERO if conviene else T.NO_QUIERO], "comparo lo que gano y lo que arriesgo en el truco")


static func _turno(r: Dictionary, v: Vista, mu: Muestreador, hipotesis: Array, perfil: PerfilIA,
		por_tipo: Dictionary, rng: RandomNumberGenerator) -> void:
	if por_tipo.has(T.ENVIDO):
		_contar(perfil, "oportunidad_envido")
		r.p_envido = p_envido(v, mu, hipotesis)
		var pe: float = r.p_envido
		var umbral := 0.66 - 0.12 * perfil.agresividad
		var farolea := pe < 0.35 and rng.randf() < perfil.farol * 0.5
		if pe > umbral or farolea:
			var tipo: int = T.ENVIDO
			if pe > 0.93 and por_tipo.has(T.FALTA_ENVIDO):
				tipo = T.FALTA_ENVIDO
			elif pe > 0.82:
				tipo = T.REAL_ENVIDO
			_elegir(r, por_tipo[tipo], "farol de envido" if farolea else "mi tanto probablemente gana")
			_contar(perfil, "envido_cantado")
			if farolea:
				_contar(perfil, "envido_farol")
			return
	var cartas := v.acciones_validas.filter(func(a: Accion) -> bool: return a.tipo == T.JUGAR_CARTA)
	var mejor: Accion = cartas[0]
	var p_mejor := -1.0
	for a: Accion in cartas:
		var p := p_mano(v, mu, hipotesis, a.carta)
		# Entre cartas casi igual de buenas, la más baja: no gastar cartas altas.
		var casi_igual := absf(p - p_mejor) <= 0.02
		if (p > p_mejor and not casi_igual) or (casi_igual and mu.muestra.poder(a.carta) < mu.muestra.poder(mejor.carta)):
			p_mejor = maxf(p, p_mejor)
			mejor = a
	r.p_mano = p_mejor
	if por_tipo.has(T.TRUCO):
		_contar(perfil, "oportunidad_truco")
		var farolea := p_mejor < 0.3 and rng.randf() < perfil.farol
		if p_mejor > 0.75 - 0.2 * perfil.agresividad or farolea:
			_elegir(r, por_tipo[T.TRUCO], "farol" if farolea else "tengo buenas chances de ganar la mano")
			_contar(perfil, "truco_cantado")
			if farolea:
				_contar(perfil, "truco_farol")
			return
	_elegir(r, mejor, "la carta con más chances de ganar la mano")


static func _elegir(r: Dictionary, a: Accion, motivo: String) -> void:
	r.accion = a
	r.motivo = motivo


static func _contar(perfil: PerfilIA, clave: String) -> void:
	if not estadisticas.has(perfil.nombre):
		estadisticas[perfil.nombre] = {}
	var d: Dictionary = estadisticas[perfil.nombre]
	d[clave] = d.get(clave, 0) + 1


## Señas que hace al empezar la mano para su compañero: la de su mejor carta
## con seña y, si tiene flor, la de flor. Si no tiene nada, «nada que valga».
static func elegir_senas(v: Vista, senas: PerfilSenas) -> Array[String]:
	var m := Muestra.new(v.muestra)
	var r: Array[String] = []
	if Tantos.tiene_flor(v.mis_iniciales, m):
		for s: Dictionary in senas.senas:
			if senas.es_flor(s.id):
				r.append(s.id)
	var cartas := v.mis_iniciales.duplicate()
	cartas.sort_custom(func(a: int, b: int) -> bool: return m.poder(a) > m.poder(b))
	for c: int in cartas:
		var s := senas.sena_de_carta(c, m)
		if s != "" and not r.has(s):
			r.append(s)
			break
	if r.is_empty():
		for s: Dictionary in senas.senas:
			if senas.es_nada(s.id):
				r.append(s.id)
	return r
