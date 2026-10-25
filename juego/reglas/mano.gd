class_name Mano
extends RefCounted
## Estado y reglas de una mano: un reparto con sus hasta tres bazas y sus
## cantos. Reglamento, puntos 6 a 10.
##
## El estado solo cambia con aplicar(). Todo lo demás es consulta. Las
## transiciones automáticas (cerrar una baza, comparar tantos, anotar) ocurren
## dentro de aplicar() y quedan registradas en el historial como eventos.
## El historial contiene solo información pública.

const JUGADORES := 4
const PARDA := 2
const NOMBRE_TRUCO: Array[String] = ["", "", "truco", "retruco", "vale cuatro"]

enum Fase { TURNO, CANTO, TERMINADA }
enum TipoCanto { TRUCO, ENVIDO, FLOR }
enum NivelFlor { CONTRA, RESTO }


## Un canto que espera respuesta. Los cantos forman una pila: un envido o una
## flor pueden suspender un truco («el envido está primero»).
class Canto:
	extends RefCounted
	var tipo: int
	## Truco: 2, 3 o 4. Flor: NivelFlor. Envido: no se usa (ver secuencia_envido).
	var nivel: int
	var cantor: int

	func _init(t: int, n: int, j: int) -> void:
		tipo = t
		nivel = n
		cantor = j

	func equipo() -> int:
		return cantor % 2


var reglamento: Reglamento
var muestra: Muestra
var repartidor: int
## Jugador mano: el de la derecha del que reparte. Gana los empates.
var jugador_mano: int
## Quién responde los cantos de cada pareja: -1 es el siguiente al que cantó;
## un número fija al jugador (D-15: la persona responde por su pareja). Las
## apuestas de flor las responde siempre quien tiene flor.
var decisor: Array[int] = [-1, -1]

var fase := Fase.TURNO
var turno: int
var baza := 0
var abre: int
var cartas: Array[Array] = []
var iniciales: Array[Array] = []
var mesa: Array[int] = [-1, -1, -1, -1]
## Resultado de cada baza cerrada: equipo ganador o PARDA.
var resultados: Array[int] = []
var cantos: Array[Canto] = []
var puntos: Array[int] = [0, 0]

## Truco: lo que vale la mano ahora (1 sin truco) y la pareja que puede subir
## (-1 mientras nadie quiso un truco).
var truco_aceptado := 1
var palabra := -1

var envido_cerrado := false
var secuencia_envido: Array[int] = []

var flores: Array[int] = []
var flor_apuesta_cerrada := false
var flor_achicado := -1
var flor_resto := false
var flor_cerrada := false

## Jugadores que muestran sus cartas al final (tanto o flor ganadores).
var mostrar: Array[int] = []
var historial: Array[Dictionary] = []
var acciones: Array[Accion] = []
var ganador_mano := -1
var ganador_partido := -1

var _tanto: Array[int] = []
var _flor: Array[int] = []


func _init(reg: Reglamento, carta_muestra: int, manos: Array, repartidor_: int, puntos_: Array[int]) -> void:
	reglamento = reg
	muestra = Muestra.new(carta_muestra)
	repartidor = repartidor_
	jugador_mano = (repartidor_ + 1) % JUGADORES
	turno = jugador_mano
	abre = jugador_mano
	puntos = puntos_.duplicate()
	var vistas := {carta_muestra: true}
	for j: int in JUGADORES:
		var c: Array[int] = []
		c.assign(manos[j])
		assert(c.size() == 3, "cada jugador recibe tres cartas")
		for x: int in c:
			assert(not vistas.has(x), "carta repetida o igual a la muestra")
			vistas[x] = true
		cartas.append(c)
		iniciales.append(c.duplicate())
		_tanto.append(Tantos.envido(c, muestra))
		_flor.append(Tantos.valor_flor(c, muestra) if Tantos.tiene_flor(c, muestra) else -1)
	_evento("reparto", {"repartidor": repartidor, "mano": jugador_mano, "muestra": carta_muestra})


static func equipo(j: int) -> int:
	return j % 2


func cartas_de(j: int) -> Array[int]:
	var r: Array[int] = []
	r.assign(cartas[j])
	return r


func iniciales_de(j: int) -> Array[int]:
	var r: Array[int] = []
	r.assign(iniciales[j])
	return r


func tiene_flor(j: int) -> bool:
	return _flor[j] >= 0


func tanto(j: int) -> int:
	return _tanto[j]


## Jugador que tiene que decidir ahora, o -1 si la mano terminó.
func actor() -> int:
	if fase == Fase.TERMINADA:
		return -1
	var forzado := _flor_obligada()
	if forzado >= 0:
		return forzado
	return _respondedor(cantos.back()) if fase == Fase.CANTO else turno


func acciones_validas(j: int) -> Array[Accion]:
	var r: Array[Accion] = []
	if j != actor():
		return r
	if _debe_cantar_flor(j):
		# La flor es obligatoria: se declara antes de jugar o de responder.
		r.append(Accion.new(Accion.Tipo.CANTAR_FLOR, j))
		if _flor_apostable(j):
			r.append(Accion.new(Accion.Tipo.CONTRAFLOR_AL_RESTO, j))
			r.append(Accion.new(Accion.Tipo.CON_FLOR_ME_ACHICO, j))
		return r
	if fase == Fase.CANTO:
		var c: Canto = cantos.back()
		r.append(Accion.new(Accion.Tipo.QUIERO, j))
		r.append(Accion.new(Accion.Tipo.NO_QUIERO, j))
		match c.tipo:
			TipoCanto.TRUCO:
				if c.nivel < 4:
					r.append(Accion.new(Accion.Tipo.TRUCO, j))
				if _envido_abierto(j):
					_agregar_envites(r, j)
			TipoCanto.ENVIDO:
				_agregar_envites(r, j)
			TipoCanto.FLOR:
				if c.nivel == NivelFlor.CONTRA:
					r.append(Accion.new(Accion.Tipo.CONTRAFLOR_AL_RESTO, j))
		return r
	for c: int in cartas[j]:
		r.append(Accion.new(Accion.Tipo.JUGAR_CARTA, j, c))
	if _envido_abierto(j):
		_agregar_envites(r, j)
	if truco_aceptado < 4 and (palabra < 0 or palabra == equipo(j)):
		r.append(Accion.new(Accion.Tipo.TRUCO, j))
	r.append(Accion.new(Accion.Tipo.IR_AL_MAZO, j))
	return r


## Aplica una acción si es válida. Devuelve {ok, error, eventos}. Si no es
## válida, el estado no cambia.
func aplicar(a: Accion) -> Dictionary:
	if not acciones_validas(a.jugador).any(func(v: Accion) -> bool: return v.es_igual(a)):
		var motivo := "no le toca a este jugador" if a.jugador != actor() else "acción no permitida en este momento"
		return {"ok": false, "error": motivo, "eventos": []}
	var desde := historial.size()
	acciones.append(a)
	var j := a.jugador
	match a.tipo:
		Accion.Tipo.JUGAR_CARTA:
			_jugar(j, a.carta)
		Accion.Tipo.CANTAR_FLOR, Accion.Tipo.CON_FLOR_ME_ACHICO:
			_declarar_flor(j, a.tipo)
		Accion.Tipo.CONTRAFLOR_AL_RESTO:
			if _debe_cantar_flor(j):
				_declarar_flor(j, a.tipo)
			else:
				_subir_flor(j)
		Accion.Tipo.ENVIDO, Accion.Tipo.REAL_ENVIDO, Accion.Tipo.FALTA_ENVIDO:
			_envite(j, a.tipo)
		Accion.Tipo.TRUCO:
			_truco(j)
		Accion.Tipo.QUIERO, Accion.Tipo.NO_QUIERO:
			_responder(j, a.tipo == Accion.Tipo.QUIERO)
		Accion.Tipo.IR_AL_MAZO:
			_evento("mazo", {"jugador": j})
			_terminar(1 - equipo(j))
	return {"ok": true, "error": "", "eventos": historial.slice(desde)}


## Copia del estado para compararlo en las pruebas (por ejemplo, que una acción
## rechazada no cambió nada).
func a_diccionario() -> Dictionary:
	var pila: Array = cantos.map(func(c: Canto) -> Array: return [c.tipo, c.nivel, c.cantor])
	return {
		"fase": fase, "turno": turno, "baza": baza, "abre": abre, "cartas": cartas.duplicate(true),
		"mesa": mesa.duplicate(), "resultados": resultados.duplicate(), "cantos": pila,
		"puntos": puntos.duplicate(), "truco": truco_aceptado, "palabra": palabra,
		"envido_cerrado": envido_cerrado, "secuencia_envido": secuencia_envido.duplicate(),
		"flores": flores.duplicate(), "historial": historial.size(),
	}


# --- Bazas ---------------------------------------------------------------

func _jugar(j: int, c: int) -> void:
	cartas[j].erase(c)
	mesa[j] = c
	_evento("carta", {"jugador": j, "carta": c, "baza": baza})
	if mesa.has(-1):
		turno = (j + 1) % JUGADORES
	else:
		_cerrar_baza()


## Gana la carta más alta. Si las más altas son iguales y de parejas distintas,
## es parda; si son de la misma pareja, gana esa pareja (reglamento, 6.1).
func _cerrar_baza() -> void:
	var maximo := -1
	var ganador := -1
	var parda := false
	for k: int in JUGADORES:
		var s := (abre + k) % JUGADORES
		var p := muestra.poder(mesa[s])
		if p > maximo:
			maximo = p
			ganador = s
			parda = false
		elif p == maximo and equipo(s) != equipo(ganador):
			parda = true
	var r := PARDA if parda else equipo(ganador)
	resultados.append(r)
	_evento("baza", {"baza": baza, "resultado": r, "jugador": -1 if parda else ganador})
	if baza == 0:
		_cerrar_flor()
		if fase == Fase.TERMINADA:
			return
	var g := _ganador_por_bazas()
	if g >= 0:
		_terminar(g)
		return
	baza += 1
	if not parda:
		abre = ganador  # tras una parda abre el mismo que abrió la baza parda
	turno = abre
	mesa.fill(-1)


## Reglamento, 6.2. Devuelve el equipo ganador o -1 si hay que seguir jugando.
func _ganador_por_bazas() -> int:
	var r := resultados
	for e: int in 2:
		if r.count(e) == 2:
			return e
	if r.size() < 2:
		return -1
	if r[0] == PARDA:
		if r[1] != PARDA:
			return r[1]
		if r.size() < 3:
			return -1
		return r[2] if r[2] != PARDA else equipo(jugador_mano)
	if r[1] == PARDA:
		return r[0]
	# Una baza para cada pareja: decide la tercera; si es parda, la primera.
	if r.size() < 3:
		return -1
	return r[0] if r[2] == PARDA else r[2]


## Fin de la mano: primero la flor, después el truco (reglamento, 10).
func _terminar(ganador: int) -> void:
	_cerrar_flor()
	if fase == Fase.TERMINADA:
		return
	ganador_mano = ganador
	_anotar(ganador, truco_aceptado, NOMBRE_TRUCO[truco_aceptado] if truco_aceptado > 1 else "mano")
	_finalizar()


# --- Truco ---------------------------------------------------------------

func _truco(j: int) -> void:
	var nivel := truco_aceptado + 1
	if fase == Fase.CANTO:
		# Subir como respuesta implica querer el canto anterior (D-08).
		var c: Canto = cantos.pop_back()
		truco_aceptado = c.nivel
		palabra = equipo(j)
		nivel = c.nivel + 1
	cantos.push_back(Canto.new(TipoCanto.TRUCO, nivel, j))
	fase = Fase.CANTO
	_evento("canto", {"jugador": j, "canto": NOMBRE_TRUCO[nivel]})


func _responder(j: int, quiero: bool) -> void:
	var c: Canto = cantos.pop_back()
	_evento("respuesta", {"jugador": j, "quiero": quiero})
	match c.tipo:
		TipoCanto.TRUCO:
			if not quiero:
				# No querer entrega lo que valía la mano antes del canto.
				_terminar(c.equipo())
				return
			truco_aceptado = c.nivel
			palabra = equipo(j)
		TipoCanto.ENVIDO:
			envido_cerrado = true
			if quiero:
				_resolver_envido()
			else:
				var previo := secuencia_envido.slice(0, -1)
				_anotar(c.equipo(), _valor_envido(previo) if not previo.is_empty() else 1, "envido no querido")
		TipoCanto.FLOR:
			flor_apuesta_cerrada = true
			if quiero:
				flor_resto = c.nivel == NivelFlor.RESTO
			else:
				flor_achicado = equipo(j)
	_volver()


func _volver() -> void:
	if fase != Fase.TERMINADA:
		fase = Fase.CANTO if not cantos.is_empty() else Fase.TURNO


# --- Envido --------------------------------------------------------------

## Se abre en la primera baza, antes de jugar la propia carta, sin flor
## declarada y sin truco querido (reglamento, 7.1).
func _envido_abierto(j: int) -> bool:
	return baza == 0 and not envido_cerrado and flores.is_empty() and truco_aceptado == 1 \
		and cartas[j].size() == 3


## Secuencia válida: hasta dos envido, hasta un real envido y una falta al
## final (reglamento, 7.2).
func _agregar_envites(r: Array[Accion], j: int) -> void:
	var s: Array[int] = []
	if _hay_canto(TipoCanto.ENVIDO):
		s = secuencia_envido
	var hay_real := s.has(Accion.Tipo.REAL_ENVIDO)
	var hay_falta := s.has(Accion.Tipo.FALTA_ENVIDO)
	if s.count(Accion.Tipo.ENVIDO) < 2 and not hay_real and not hay_falta:
		r.append(Accion.new(Accion.Tipo.ENVIDO, j))
	if not hay_real and not hay_falta:
		r.append(Accion.new(Accion.Tipo.REAL_ENVIDO, j))
	if not hay_falta:
		r.append(Accion.new(Accion.Tipo.FALTA_ENVIDO, j))


func _envite(j: int, tipo: int) -> void:
	if _hay_canto(TipoCanto.ENVIDO):
		cantos.pop_back()
	else:
		secuencia_envido.clear()
	secuencia_envido.append(tipo)
	cantos.push_back(Canto.new(TipoCanto.ENVIDO, 0, j))
	fase = Fase.CANTO
	var nombres := {Accion.Tipo.ENVIDO: "envido", Accion.Tipo.REAL_ENVIDO: "real envido", Accion.Tipo.FALTA_ENVIDO: "falta envido"}
	_evento("canto", {"jugador": j, "canto": nombres[tipo]})


func _valor_envido(s: Array[int]) -> int:
	if s.has(Accion.Tipo.FALTA_ENVIDO):
		return reglamento.valor_falta(puntos)
	return 2 * s.count(Accion.Tipo.ENVIDO) + 3 * s.count(Accion.Tipo.REAL_ENVIDO)


## Se declaran desde la mano: cada uno habla solo si supera al mejor de la
## pareja contraria; si no, «son buenas». Empate: gana el más cercano a la mano.
func _resolver_envido() -> void:
	var mejor := -1
	for k: int in JUGADORES:
		var s := (jugador_mano + k) % JUGADORES
		if mejor >= 0 and equipo(s) == equipo(mejor):
			continue
		if mejor < 0 or _tanto[s] > _tanto[mejor]:
			mejor = s
			_evento("tanto", {"jugador": s, "tanto": _tanto[s]})
		else:
			_evento("son_buenas", {"jugador": s})
	mostrar.append(mejor)
	_anotar(equipo(mejor), _valor_envido(secuencia_envido), "envido")


# --- Flor ----------------------------------------------------------------

func _debe_cantar_flor(j: int) -> bool:
	return baza == 0 and fase != Fase.TERMINADA and _flor[j] >= 0 and not flores.has(j) \
		and cartas[j].size() == 3


## Quien tiene que declarar su flor antes de seguir: el que debe actuar o, si
## hay un envido cantado, cualquiera con flor sin declarar (la flor lo anula).
func _flor_obligada() -> int:
	if baza > 0:
		return -1
	var natural := _respondedor(cantos.back()) if fase == Fase.CANTO else turno
	if _debe_cantar_flor(natural):
		return natural
	if _hay_canto(TipoCanto.ENVIDO):
		for k: int in JUGADORES:
			var j := (jugador_mano + k) % JUGADORES
			if _debe_cantar_flor(j):
				return j
	return -1


## Se puede apostar al declarar si la otra pareja ya tiene flor y la apuesta
## sigue abierta (reglamento, 8.2).
func _flor_apostable(j: int) -> bool:
	return not flor_apuesta_cerrada and not _hay_canto(TipoCanto.FLOR) \
		and flores.any(func(s: int) -> bool: return equipo(s) != equipo(j))


func _declarar_flor(j: int, tipo: int) -> void:
	var apostable := _flor_apostable(j)
	flores.append(j)
	_evento("flor", {"jugador": j})
	if not envido_cerrado:
		# La flor anula el envido, aunque ya se haya cantado.
		envido_cerrado = true
		if _hay_canto(TipoCanto.ENVIDO):
			cantos.pop_back()
			_evento("envido_anulado", {})
	match tipo:
		Accion.Tipo.CANTAR_FLOR:
			if apostable:
				cantos.push_back(Canto.new(TipoCanto.FLOR, NivelFlor.CONTRA, j))
		Accion.Tipo.CONTRAFLOR_AL_RESTO:
			cantos.push_back(Canto.new(TipoCanto.FLOR, NivelFlor.RESTO, j))
			_evento("canto", {"jugador": j, "canto": "contraflor al resto"})
		Accion.Tipo.CON_FLOR_ME_ACHICO:
			flor_achicado = equipo(j)
			flor_apuesta_cerrada = true
			_evento("canto", {"jugador": j, "canto": "con flor me achico"})
	_volver()


func _subir_flor(j: int) -> void:
	cantos.pop_back()
	cantos.push_back(Canto.new(TipoCanto.FLOR, NivelFlor.RESTO, j))
	_evento("canto", {"jugador": j, "canto": "contraflor al resto"})


## Se anota al cerrar la primera baza o al terminar la mano, cuando ya se
## declararon todas las flores. Reglamento, 8.2.
func _cerrar_flor() -> void:
	if flor_cerrada:
		return
	flor_cerrada = true
	if flores.is_empty():
		return
	var cuenta: Array[int] = [0, 0]
	for s: int in flores:
		cuenta[equipo(s)] += 1
	var base := reglamento.puntos_por_flor
	var ganador := -1
	var pts := 0
	if cuenta[0] == 0 or cuenta[1] == 0 or flor_achicado >= 0:
		ganador = 1 - flor_achicado if flor_achicado >= 0 else (0 if cuenta[0] > 0 else 1)
		pts = base * cuenta[ganador]
		for s: int in flores:
			if equipo(s) == ganador:
				mostrar.append(s)
	else:
		var mejor := -1
		for k: int in JUGADORES:
			var s := (jugador_mano + k) % JUGADORES
			if flores.has(s):
				_evento("valor_flor", {"jugador": s, "flor": _flor[s]})
				if mejor < 0 or _flor[s] > _flor[mejor]:
					mejor = s
		mostrar.append(mejor)
		ganador = equipo(mejor)
		pts = reglamento.valor_falta(puntos) if flor_resto else base * flores.size()
	_anotar(ganador, pts, "contraflor al resto" if flor_resto else "flor")


# --- Utilidades ------------------------------------------------------------

func _respondedor(c: Canto) -> int:
	var e := 1 - c.equipo()
	if c.tipo == TipoCanto.FLOR:
		for s: int in flores:
			if equipo(s) == e:
				return s
	return decisor[e] if decisor[e] >= 0 else (c.cantor + 1) % JUGADORES


func _hay_canto(tipo: int) -> bool:
	return not cantos.is_empty() and cantos.back().tipo == tipo


func _anotar(e: int, pts: int, motivo: String) -> void:
	if pts <= 0 or fase == Fase.TERMINADA:
		return
	var antes := puntos[e]
	puntos[e] = mini(reglamento.objetivo, antes + pts)
	_evento("puntos", {"equipo": e, "puntos": puntos[e] - antes, "motivo": motivo, "tanteador": puntos.duplicate()})
	if puntos[e] >= reglamento.objetivo:
		# El partido termina en ese momento, aunque la mano no haya terminado.
		ganador_partido = e
		_finalizar()


func _finalizar() -> void:
	if fase == Fase.TERMINADA:
		return
	fase = Fase.TERMINADA
	var mostradas := {}
	for s: int in mostrar:
		mostradas[s] = iniciales_de(s)
	_evento("fin_mano", {"ganador_mano": ganador_mano, "ganador_partido": ganador_partido, "mostrar": mostradas})


func _evento(tipo: String, datos: Dictionary) -> void:
	datos["tipo"] = tipo
	historial.append(datos)
