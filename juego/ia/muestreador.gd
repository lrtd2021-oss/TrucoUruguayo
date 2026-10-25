class_name Muestreador
extends RefCounted
## Arma hipótesis de las cartas que un jugador no ve, coherentes con lo que
## sabe legítimamente por su Vista: cartas jugadas, tantos y flores declarados,
## quién jugó sin cantar flor, y las señas que hizo o vio. Nunca mira la Mano.
##
## Las señas se toman como verdaderas (nadie le miente a su compañero). Si una
## seña contradice lo visto, se descarta. Los cantos ajenos también informan,
## aunque se puede farolear: quien canta envido suele tener buen tanto y quien
## canta o sube el truco suele tener cartas fuertes (restricciones blandas). Las restricciones de tanto y flor se
## cumplen por rechazo con un límite de intentos: si no se logra, se usa la
## hipótesis que menos restricciones viola (aproximación documentada).

const INTENTOS := 20

var v: Vista
var muestra: Muestra
var jugadas: Array[Array] = [[], [], [], []]
var desconocidas: Array[int] = []
var faltan: Array[int] = [0, 0, 0, 0]
## Por jugador: conjuntos de cartas de los que tiene al menos una (señas).
var obligatorias: Array[Array] = [[], [], [], []]
## Por jugador: cartas que no tiene («nada que valga»).
var prohibidas: Array[Dictionary] = [{}, {}, {}, {}]
var tanto_exacto: Array[int] = [-1, -1, -1, -1]
var tanto_maximo: Array[int] = [99, 99, 99, 99]
## -1 no se sabe, 0 no tiene, 1 tiene.
var flor: Array[int] = [-1, -1, -1, -1]
var flor_exacta: Array[int] = [-1, -1, -1, -1]
## Inferencias de los cantos ajenos: tanto mínimo y cantidad mínima de cartas
## fuertes (matas o piezas) entre las tres iniciales.
var tanto_minimo: Array[int] = [-1, -1, -1, -1]
var fuertes_minimo: Array[int] = [0, 0, 0, 0]

const TANTO_POR_CANTO := {"envido": 26, "real envido": 28, "falta envido": 30}
const FUERTES_POR_CANTO := {"truco": 1, "retruco": 2, "vale cuatro": 2}


func _init(vista: Vista, perfil_senas: PerfilSenas, usar_inferencias: bool) -> void:
	v = vista
	muestra = Muestra.new(v.muestra)
	var vistas := {v.muestra: true}
	for c: int in v.mis_iniciales:
		vistas[c] = true
	var mejor_declarado := -1
	var cantaron_flor := {}
	for e: Dictionary in v.historial:
		match e.tipo:
			"carta":
				var j: int = e.jugador
				jugadas[j].append(e.carta)
				vistas[e.carta] = true
				if int(e.baza) == 0 and not cantaron_flor.has(j):
					flor[j] = 0  # jugó sin declarar flor: no tiene
			"flor":
				cantaron_flor[int(e.jugador)] = true
				flor[e.jugador] = 1
			"valor_flor":
				flor_exacta[e.jugador] = e.flor
			"tanto":
				tanto_exacto[e.jugador] = e.tanto
				mejor_declarado = e.tanto
			"son_buenas":
				tanto_maximo[e.jugador] = mejor_declarado
			"canto":
				var j: int = e.jugador
				if j != v.jugador:
					tanto_minimo[j] = maxi(tanto_minimo[j], TANTO_POR_CANTO.get(e.canto, -1))
					fuertes_minimo[j] = maxi(fuertes_minimo[j], FUERTES_POR_CANTO.get(e.canto, 0))
	for c: int in Carta.mazo():
		if not vistas.has(c):
			desconocidas.append(c)
	for j: int in Mano.JUGADORES:
		faltan[j] = 0 if j == v.jugador else 3 - jugadas[j].size()
	if usar_inferencias:
		_leer_senas(perfil_senas)
	else:
		tanto_exacto.fill(-1)
		tanto_maximo.fill(99)
		flor_exacta.fill(-1)
		tanto_minimo.fill(-1)
		fuertes_minimo.fill(0)


func _leer_senas(perfil: PerfilSenas) -> void:
	if perfil == null:
		return
	for s: Dictionary in v.senas:
		var e: int = s.emisor
		if e == v.jugador:
			continue
		if perfil.es_flor(s.sena):
			flor[e] = 1
		elif perfil.es_nada(s.sena):
			for c: int in perfil.cartas_con_sena(muestra):
				prohibidas[e][c] = true
		else:
			var cartas := perfil.cartas_de(s.sena, muestra)
			if cartas.any(func(c: int) -> bool: return c in jugadas[e]):
				continue  # ya la jugó: la seña está cumplida
			var posibles: Array[int] = cartas.filter(func(c: int) -> bool: return c in desconocidas)
			if not posibles.is_empty():
				obligatorias[e].append(posibles)


## Una hipótesis: las cartas que le quedan a cada jugador (vacío para quien
## decide, que conoce las suyas).
func muestrear(rng: RandomNumberGenerator) -> Array[Array]:
	var mejor: Array[Array] = []
	var menos_fallas := 1000
	for intento: int in INTENTOS:
		var manos := _repartir(rng)
		var fallas := _fallas(manos)
		if fallas == 0:
			return manos
		if fallas < menos_fallas:
			menos_fallas = fallas
			mejor = manos
	return mejor


func _repartir(rng: RandomNumberGenerator) -> Array[Array]:
	var pozo := desconocidas.duplicate()
	Carta.mezclar(pozo, rng)
	var manos: Array[Array] = [[], [], [], []]
	var orden: Array[int] = [0, 1, 2, 3]
	Carta.mezclar(orden, rng)
	for j: int in orden:
		for conjunto: Array in obligatorias[j]:
			if manos[j].size() >= faltan[j]:
				break
			var candidatas := conjunto.filter(func(c: int) -> bool: return c in pozo)
			if not candidatas.is_empty():
				var c: int = candidatas[rng.randi_range(0, candidatas.size() - 1)]
				manos[j].append(c)
				pozo.erase(c)
	for j: int in orden:
		var i := 0
		while manos[j].size() < faltan[j] and not pozo.is_empty():
			if i >= pozo.size():
				i = 0  # no hay cartas permitidas: se relaja la prohibición
				manos[j].append(pozo.pop_front())
				continue
			if prohibidas[j].has(pozo[i]):
				i += 1
				continue
			manos[j].append(pozo[i])
			pozo.remove_at(i)
	return manos


func _fallas(manos: Array[Array]) -> int:
	var fallas := 0
	for j: int in Mano.JUGADORES:
		if j == v.jugador:
			continue
		if tanto_exacto[j] < 0 and tanto_maximo[j] == 99 and flor[j] < 0 and tanto_minimo[j] < 0 and fuertes_minimo[j] == 0:
			continue
		var completa := iniciales_hipoteticas(manos, j)
		var tiene_flor := Tantos.tiene_flor(completa, muestra)
		if flor[j] >= 0 and tiene_flor != (flor[j] == 1):
			fallas += 1
		if flor_exacta[j] >= 0 and tiene_flor and Tantos.valor_flor(completa, muestra) != flor_exacta[j]:
			fallas += 1
		if tanto_exacto[j] >= 0 or tanto_maximo[j] < 99 or tanto_minimo[j] >= 0:
			var t := Tantos.envido(completa, muestra)
			if (tanto_exacto[j] >= 0 and t != tanto_exacto[j]) or t > tanto_maximo[j]:
				fallas += 2  # lo declarado es seguro
			elif tanto_exacto[j] < 0 and t < tanto_minimo[j]:
				fallas += 1  # el canto pudo ser un farol
		if fuertes_minimo[j] > 0:
			var fuertes := completa.filter(func(c: int) -> bool: return muestra.poder(c) >= 11).size()
			if fuertes < fuertes_minimo[j]:
				fallas += 1
	return fallas


## Las tres cartas iniciales de un jugador en una hipótesis.
func iniciales_hipoteticas(manos: Array[Array], j: int) -> Array[int]:
	var r: Array[int] = []
	if j == v.jugador:
		r.assign(v.mis_iniciales)
		return r
	r.assign(jugadas[j])
	r.append_array(manos[j])
	return r
