extends GutTest
## Medición de la fuerza de la IA (tarea 4.1). No forma parte de la batería
## común porque tarda varios minutos: se ejecuta con herramientas/medir_ia.sh.
##
## Cada reparto se juega dos veces, cambiando de pareja a la IA, para que la
## suerte de las cartas se compense.

const PARTIDOS_ALEATORIA := 1000
const PARTIDOS_BASICA := 200

var senas := PerfilSenas.cargar()


func test_medir_contra_aleatoria() -> void:
	var r := enfrentar("aleatoria", PARTIDOS_ALEATORIA, PerfilIA.Dificultad.NORMAL)
	gut.p("contra la IA aleatoria: %d de %d (%.1f %%), decisión media %.1f ms, máxima %.1f ms" % r)
	assert_gt(float(r[0]) / r[1], 0.8, "criterio de la tarea 4.1")


func test_medir_contra_basica() -> void:
	var r := enfrentar("basica", PARTIDOS_BASICA, PerfilIA.Dificultad.NORMAL)
	gut.p("contra la IA básica: %d de %d (%.1f %%), decisión media %.1f ms, máxima %.1f ms" % r)
	assert_gt(float(r[0]) / r[1], 0.5, "le gana a la IA provisional de la Fase 3")


## Devuelve [ganados, jugados, porcentaje, ms medio, ms máximo].
func enfrentar(rival: String, partidos: int, dificultad: PerfilIA.Dificultad) -> Array:
	var ganados := 0
	var tiempos: Array[int] = []
	@warning_ignore("integer_division")
	for s: int in partidos / 2:
		if _partido(s, "muestreo", rival, dificultad, tiempos) == 0:
			ganados += 1
		if _partido(s, rival, "muestreo", dificultad, tiempos) == 1:
			ganados += 1
	var total: int = tiempos.reduce(func(a: int, b: int) -> int: return a + b, 0)
	return [ganados, partidos, 100.0 * ganados / partidos, total / 1000.0 / tiempos.size(), float(tiempos.max()) / 1000.0]


func _partido(semilla: int, ia_a: String, ia_b: String, dificultad: PerfilIA.Dificultad, tiempos: Array[int]) -> int:
	var rng := RandomNumberGenerator.new()
	rng.seed = semilla
	var p := Partido.new(Reglamento.new(), semilla, semilla % 4)
	var perfil := PerfilIA.crear("neutral", dificultad)
	while p.ganador < 0 and p.manos_jugadas < 300:
		var m := p.nueva_mano()
		while m.fase != Mano.Fase.TERMINADA:
			var a := m.actor()
			var tipo := ia_a if Mano.equipo(a) == 0 else ia_b
			var v := Vista.para(m, a)
			var acc: Accion
			match tipo:
				"muestreo":
					var t0 := Time.get_ticks_usec()
					acc = IaMuestreo.decidir(v, perfil, senas, rng)
					tiempos.append(Time.get_ticks_usec() - t0)
				"basica":
					acc = IaBasica.decidir(v, rng)
				_:
					acc = IaAleatoria.decidir(v, rng)
			assert_true(m.aplicar(acc).ok, "acción legal")
		p.cerrar_mano()
	return p.ganador
