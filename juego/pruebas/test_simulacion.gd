extends GutTest
## Caso R-67: muchos partidos con decisiones al azar terminan sin bloqueos,
## sin acciones rechazadas y con el tanteador coherente.

const PARTIDOS := 1000
const MAX_ACCIONES_POR_MANO := 200
## Situaciones que la simulación tiene que haber recorrido al menos una vez,
## para que «terminó sin bloqueos» signifique algo.
const COBERTURA: Array[String] = [
	"truco", "retruco", "vale cuatro", "envido", "real envido", "falta envido",
	"contraflor al resto", "con flor me achico", "flor", "envido_anulado",
	"son_buenas", "valor_flor", "parda", "mazo", "fin_por_tantos",
]


func test_R67_partidos_al_azar_terminan_bien() -> void:
	var rng := RandomNumberGenerator.new()
	var manos_total := 0
	var fallos := 0
	var vistas := {}
	for semilla: int in PARTIDOS:
		rng.seed = semilla
		var p := Partido.new(Reglamento.new(), semilla, semilla % 4)
		var anotado: Array[int] = [0, 0]
		while p.ganador < 0 and p.manos_jugadas < 500:
			var m := p.nueva_mano()
			var pasos := 0
			while m.fase != Mano.Fase.TERMINADA and pasos < MAX_ACCIONES_POR_MANO:
				pasos += 1
				var r := m.aplicar(IaAleatoria.decidir(Vista.para(m, m.actor()), rng))
				if not r.ok:
					fallos += 1
			if not _cartas_conservadas(m):
				fallos += 1
			for e: Dictionary in m.historial:
				if e.tipo == "puntos":
					anotado[e.equipo] += e.puntos
				_registrar(e, vistas)
			if m.fase != Mano.Fase.TERMINADA:
				fallos += 1
				break
			p.cerrar_mano()
			manos_total += 1
		if p.ganador < 0 or p.puntos[p.ganador] != p.reglamento.objetivo or anotado != p.puntos:
			fallos += 1
	gut.p("%d partidos, %d manos" % [PARTIDOS, manos_total])
	gut.p("situaciones: %s" % vistas)
	assert_eq(fallos, 0, "partidos con bloqueos, acciones rechazadas o tanteador incoherente")
	for situacion: String in COBERTURA:
		assert_true(vistas.has(situacion), "la simulación pasó por: " + situacion)


func _registrar(e: Dictionary, vistas: Dictionary) -> void:
	var clave := ""
	match e.tipo:
		"canto":
			clave = e.canto
		"flor", "envido_anulado", "son_buenas", "valor_flor", "mazo":
			clave = e.tipo
		"baza":
			clave = "parda" if e.resultado == Mano.PARDA else ""
		"fin_mano":
			# El partido terminó por tantos, con cartas todavía en la mano.
			if e.ganador_partido >= 0 and e.ganador_mano < 0:
				clave = "fin_por_tantos"
	if clave != "":
		vistas[clave] = vistas.get(clave, 0) + 1


## Las cartas en mano más las jugadas son siempre las tres de cada jugador.
func _cartas_conservadas(m: Mano) -> bool:
	var jugadas := {}
	for e: Dictionary in m.historial:
		if e.tipo == "carta":
			jugadas[e.carta] = e.jugador
	for j: int in 4:
		for c: int in m.iniciales_de(j):
			if m.cartas_de(j).has(c) == jugadas.has(c):
				return false
	return true
