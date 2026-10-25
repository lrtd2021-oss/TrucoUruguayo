class_name ControladorMesa
extends Node
## Une el motor de reglas con quien decide en cada asiento (la persona, la IA
## o un guion) y con la presentación. Es el dueño del partido.
##
## La presentación nunca cambia el estado: recibe los eventos con la señal
## eventos_aplicados y, si esperar_presentacion está activo, avisa con
## presentacion_terminada() cuando terminó de mostrarlos. Hasta entonces no se
## aplica ninguna otra acción, así que un clic doble o una IA apurada no pueden
## adelantarse a lo que se ve en pantalla.

enum Fuente { HUMANO, IA, GUION }

signal eventos_aplicados(eventos: Array[Dictionary])
signal espera_humano(jugador: int)
signal mano_cerrada
signal error_guion(mensaje: String)

var reglamento := Reglamento.new()
var partido: Partido
var mano: Mano
var fuentes: Array[int] = [Fuente.HUMANO, Fuente.IA, Fuente.IA, Fuente.IA]
## Acciones en orden para los asientos con fuente GUION (demos del tutorial).
var guion: Array[Accion] = []
var pausado := false
var presentando := false
var esperar_presentacion := false
## En el juego, la IA avanza sola con un retardo. Las pruebas lo apagan y
## llaman a paso().
var automatico := true
var retardo_ia := 0.7
var rng_ia := RandomNumberGenerator.new()

var _espera := 0.0
var _mano_cerrada := false


func iniciar(semilla: int, repartidor := 3) -> void:
	partido = Partido.new(reglamento, semilla, repartidor)
	rng_ia.seed = semilla
	# D-15: si hay una persona en la pareja, ella responde los cantos.
	var decisor: Array[int] = [-1, -1]
	for j: int in Mano.JUGADORES:
		if fuentes[j] == Fuente.HUMANO:
			decisor[Mano.equipo(j)] = j
	partido.decisor = decisor
	nueva_mano()


func nueva_mano() -> void:
	mano = partido.nueva_mano()
	_mano_cerrada = false
	_publicar(mano.historial.duplicate(true))
	_avisar_si_humano()


## Pasa a la mano siguiente si la actual terminó y el partido sigue.
func siguiente_mano() -> bool:
	if mano == null or mano.fase != Mano.Fase.TERMINADA or partido.ganador >= 0 or presentando:
		return false
	nueva_mano()
	return true


func actor() -> int:
	return mano.actor() if mano else -1


func esperando_humano() -> bool:
	var a := actor()
	return a >= 0 and fuentes[a] == Fuente.HUMANO and _libre()


## Acción de la persona. Se rechaza si no le toca, si está en pausa, si la
## presentación todavía está animando o si la acción ya no es válida.
func solicitar(a: Accion) -> bool:
	if not esperando_humano() or a.jugador != actor():
		return false
	return _aplicar(a)


## Hace avanzar una acción de la IA o del guion. Devuelve si aplicó algo.
func paso() -> bool:
	if not _libre() or mano == null or mano.fase == Mano.Fase.TERMINADA:
		return false
	var a := actor()
	match fuentes[a]:
		Fuente.IA:
			return _aplicar(IaBasica.decidir(Vista.para(mano, a), rng_ia))
		Fuente.GUION:
			if guion.is_empty():
				error_guion.emit("el guion no tiene acciones para el jugador %d" % a)
				return false
			var acc: Accion = guion.pop_front()
			if not _aplicar(acc):
				error_guion.emit("acción de guion rechazada: %s" % acc)
				return false
			return true
	return false


func pausar(valor: bool) -> void:
	pausado = valor
	_espera = 0.0
	if not valor:
		_avisar_si_humano()


func presentacion_terminada() -> void:
	presentando = false
	_avisar_si_humano()


func _process(delta: float) -> void:
	if not automatico or not _libre() or mano == null or mano.fase == Mano.Fase.TERMINADA:
		_espera = 0.0
		return
	if fuentes[actor()] == Fuente.HUMANO:
		return
	_espera += delta
	if _espera >= retardo_ia:
		_espera = 0.0
		paso()


func _libre() -> bool:
	return not pausado and not presentando


func _aplicar(a: Accion) -> bool:
	var r := mano.aplicar(a)
	if not r.ok:
		return false
	if mano.fase == Mano.Fase.TERMINADA and not _mano_cerrada:
		_mano_cerrada = true
		partido.cerrar_mano()
	var eventos: Array[Dictionary] = []
	eventos.assign(r.eventos)
	_publicar(eventos)
	if mano.fase == Mano.Fase.TERMINADA:
		mano_cerrada.emit()
	else:
		_avisar_si_humano()
	return true


func _publicar(eventos: Array[Dictionary]) -> void:
	if esperar_presentacion:
		presentando = true
	eventos_aplicados.emit(eventos)


func _avisar_si_humano() -> void:
	if esperando_humano():
		espera_humano.emit(actor())
