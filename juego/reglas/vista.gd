class_name Vista
extends RefCounted
## Lo que un jugador puede saber de una mano. La IA y el asistente reciben
## solo esto, nunca la Mano completa, así no pueden ver cartas ocultas.

var jugador: int
var muestra: int
var mis_cartas: Array[int] = []
var mis_iniciales: Array[int] = []
var jugador_mano: int
var turno: int
var actor: int
var baza: int
var fase: int
var puntos: Array[int] = []
var truco_aceptado: int
## Canto que espera respuesta (Mano.TipoCanto) y su nivel, o -1 si no hay.
var canto_pendiente := -1
var nivel_canto := -1
## Resultado de cada baza cerrada: equipo ganador o Mano.PARDA.
var resultados: Array[int] = []
## Historial de eventos públicos: cartas jugadas, cantos, tantos declarados.
var historial: Array[Dictionary] = []
## Cartas que se mostraron al terminar la mano (solo después del final).
var mostradas: Dictionary = {}
var acciones_validas: Array[Accion] = []


static func para(m: Mano, j: int) -> Vista:
	var v := Vista.new()
	v.jugador = j
	v.muestra = m.muestra.carta
	v.mis_cartas = m.cartas_de(j)
	v.mis_iniciales = m.iniciales_de(j)
	v.jugador_mano = m.jugador_mano
	v.turno = m.turno
	v.actor = m.actor()
	v.baza = m.baza
	v.fase = m.fase
	v.puntos = m.puntos.duplicate()
	v.truco_aceptado = m.truco_aceptado
	if m.fase == Mano.Fase.CANTO:
		var c: Mano.Canto = m.cantos.back()
		v.canto_pendiente = c.tipo
		v.nivel_canto = c.nivel
	v.resultados = m.resultados.duplicate()
	v.historial = m.historial.duplicate(true)
	if m.fase == Mano.Fase.TERMINADA and not m.historial.is_empty():
		var fin: Dictionary = m.historial.back()
		if fin.tipo == "fin_mano":
			v.mostradas = fin.mostrar.duplicate(true)
	v.acciones_validas = m.acciones_validas(j)
	return v


## Todas las cartas que este jugador tiene a la vista: las suyas, la muestra,
## las jugadas y las mostradas. Sirve para comprobar que no ve nada más.
func cartas_visibles() -> Array[int]:
	var r: Array[int] = mis_iniciales.duplicate()
	r.append(muestra)
	for e: Dictionary in historial:
		if e.tipo == "carta":
			r.append(e.carta)
		elif e.tipo == "fin_mano":
			for s: int in e.mostrar:
				r.append_array(e.mostrar[s])
	return r


## Cartas jugadas en la baza en curso: jugador -> carta.
func mesa_actual() -> Dictionary:
	var r := {}
	for e: Dictionary in historial:
		if e.tipo == "carta" and e.baza == baza:
			r[e.jugador] = e.carta
		elif e.tipo == "baza" and e.baza == baza:
			r.clear()
	return r
