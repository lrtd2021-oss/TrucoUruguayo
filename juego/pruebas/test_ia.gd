extends GutTest
## Fase 4: IA por muestreo, personalidades, señas en la partida y asistente.

const H := preload("res://pruebas/ayuda.gd")
const T := Accion.Tipo

var senas := PerfilSenas.cargar()


func _jugar_partido(semilla: int, perfiles: Array[PerfilIA], decidir_equipo_b: Callable = Callable()) -> Partido:
	var rng := RandomNumberGenerator.new()
	rng.seed = semilla
	var p := Partido.new(Reglamento.new(), semilla, semilla % 4)
	while p.ganador < 0 and p.manos_jugadas < 300:
		var m := p.nueva_mano()
		var registro := RegistroSenas.new()
		while m.fase != Mano.Fase.TERMINADA:
			var a := m.actor()
			var v := Vista.para(m, a, registro)
			var acc: Accion
			if decidir_equipo_b.is_valid() and Mano.equipo(a) == 1:
				acc = decidir_equipo_b.call(v, rng)
			else:
				acc = IaMuestreo.decidir(v, perfiles[a], senas, rng)
			var r := m.aplicar(acc)
			assert_true(r.ok, "la IA eligió una acción legal: %s" % acc)
			if not r.ok:
				return p
		p.cerrar_mano()
	return p


func test_41_siempre_elige_acciones_legales() -> void:
	var perfiles: Array[PerfilIA] = []
	for nombre: String in ["tito", "marta", "cacho", "rosario"]:
		perfiles.append(PerfilIA.crear(nombre, PerfilIA.Dificultad.FACIL))
	for semilla: int in 20:
		var p := _jugar_partido(semilla, perfiles)
		assert_gt(p.ganador, -1, "el partido terminó")


## Versión corta del criterio 4.1 (la medición completa de 1000 partidos está
## en mediciones/ y se ejecuta con herramientas/medir_ia.sh).
func test_41_le_gana_a_la_ia_aleatoria() -> void:
	var perfiles: Array[PerfilIA] = []
	for j: int in 4:
		perfiles.append(PerfilIA.crear("neutral", PerfilIA.Dificultad.NORMAL))
	var ganados := 0
	var partidos := 40
	for semilla: int in partidos:
		var p := _jugar_partido(semilla, perfiles, IaAleatoria.decidir)
		if p.ganador == 0:
			ganados += 1
	gut.p("contra la aleatoria: %d de %d" % [ganados, partidos])
	assert_gt(float(ganados) / partidos, 0.8)


## La IA no puede usar cartas ocultas: con la misma información pública y
## cartas rivales distintas, decide exactamente lo mismo. Decide el compañero
## (2): el rival 1 jugó la misma carta en los dos casos, pero sus otras cartas
## y las del rival 3 son distintas.
func test_R65_la_ia_decide_igual_si_cambian_las_cartas_ocultas() -> void:
	var previas: Array[Accion] = [H.carta(0, "3B"), H.carta(1, "2B")]
	var a := Escenario.construir("1C", ["7O 6O 3B", "7E 5E 2B", "12O 4E 1B", "6B 3E 11O"], previas)
	var b := Escenario.construir("1C", ["7O 6O 3B", "2B 11E 4O", "12O 4E 1B", "2O 7B 10E"], previas)
	var perfil := PerfilIA.crear("neutral", PerfilIA.Dificultad.DIFICIL)
	var va := Vista.para(a.mano, 2)
	var vb := Vista.para(b.mano, 2)
	assert_eq(va.cartas_visibles(), vb.cartas_visibles(), "misma información visible")
	var rng_a := RandomNumberGenerator.new()
	var rng_b := RandomNumberGenerator.new()
	rng_a.seed = 5
	rng_b.seed = 5
	var da := IaMuestreo.decidir_con_detalle(va, perfil, senas, rng_a)
	var db := IaMuestreo.decidir_con_detalle(vb, perfil, senas, rng_b)
	assert_not_null(da.accion)
	assert_eq(str(da.accion), str(db.accion))
	assert_eq(da.p_mano, db.p_mano)
	assert_eq(da.p_envido, db.p_envido)


func test_ia_sin_turno_no_decide_nada() -> void:
	var m := Escenario.mano("1C", ["7O 6O 3B", "7E 5E 2B", "12O 4E 1B", "6B 3E 11O"])
	var d := IaMuestreo.decidir_con_detalle(Vista.para(m, 2), PerfilIA.crear("neutral"), senas, RandomNumberGenerator.new())
	assert_null(d.accion)


func test_42_las_personalidades_se_distinguen() -> void:
	IaMuestreo.estadisticas.clear()
	var perfiles: Array[PerfilIA] = []
	for nombre: String in ["tito", "marta", "cacho", "rosario"]:
		perfiles.append(PerfilIA.crear(nombre, PerfilIA.Dificultad.NORMAL))
	for semilla: int in 30:
		_jugar_partido(1000 + semilla, perfiles)
	var e := IaMuestreo.estadisticas
	var tasa := func(nombre: String, clave: String, base: String) -> float:
		return float(e[nombre].get(clave, 0)) / maxf(1.0, e[nombre].get(base, 0))
	for nombre: String in ["tito", "marta", "cacho", "rosario"]:
		gut.p("%s: truco %.2f, farol de truco %d, envido %.2f, farol de envido %d" % [nombre,
			tasa.call(nombre, "truco_cantado", "oportunidad_truco"), e[nombre].get("truco_farol", 0),
			tasa.call(nombre, "envido_cantado", "oportunidad_envido"), e[nombre].get("envido_farol", 0)])
	for arriesgado: String in ["tito", "cacho"]:
		for prudente: String in ["marta", "rosario"]:
			assert_gt(tasa.call(arriesgado, "truco_cantado", "oportunidad_truco"),
				tasa.call(prudente, "truco_cantado", "oportunidad_truco"), "%s grita más truco que %s" % [arriesgado, prudente])
			assert_gt(e[arriesgado].get("truco_farol", 0), e[prudente].get("truco_farol", 0), "%s farolea más que %s" % [arriesgado, prudente])


func test_43_elige_senas_segun_su_mano() -> void:
	var m := Escenario.mano("3O", ["2O 6C 12B", "7E 5E 2B", "12O 4E 1B", "7B 6B 4B"])
	assert_eq(IaMuestreo.elegir_senas(Vista.para(m, 0), senas), ["cejas"] as Array[String], "el 2 de la muestra")
	assert_eq(IaMuestreo.elegir_senas(Vista.para(m, 1), senas), ["mueca_izquierda"] as Array[String], "el 7 de espadas")
	assert_eq(IaMuestreo.elegir_senas(Vista.para(m, 3), senas), ["cachetes"] as Array[String], "flor sin cartas con seña")
	m = Escenario.mano("3O", ["12C 6C 4B", "7E 5E 2B", "12O 4E 1B", "7B 6B 3B"])
	assert_eq(IaMuestreo.elegir_senas(Vista.para(m, 0), senas), ["ojos_cerrados"] as Array[String], "nada que valga")


## Tarea 4.5: el compañero IA usa la seña que vio. Tercera baza, abre el
## compañero (2) y decide si grita truco; el resultado depende de la última
## carta de la persona (0), que él no ve. Si la persona le dijo «tengo el 2 de
## la muestra», grita; si le dijo «nada que valga», juega sin gritar.
func test_45_el_companero_cambia_su_decision_segun_la_sena() -> void:
	var manos: Array[String] = ["2O 6C 4B", "7C 5E 4E", "1C 6O 5B", "3E 11C 10B"]
	var previas: Array[Accion] = [
		H.carta(0, "4B"), H.carta(1, "4E"), H.carta(2, "5B"), H.carta(3, "3E"),
		H.carta(3, "10B"), H.carta(0, "6C"), H.carta(1, "5E"), H.carta(2, "1C"),
	]
	var resultados := {}
	for sena: String in ["cejas", "ojos_cerrados"]:
		var r := Escenario.construir("3O", manos, previas)
		assert_eq(r.error, "")
		var m: Mano = r.mano
		assert_eq(m.actor(), 2, "abre la tercera baza el compañero")
		var registro := RegistroSenas.new()
		registro.hechas = [{"emisor": 0, "sena": sena, "vieron": [2]}] as Array[Dictionary]
		var rng := RandomNumberGenerator.new()
		rng.seed = 9
		resultados[sena] = IaMuestreo.decidir_con_detalle(Vista.para(m, 2, registro), PerfilIA.crear("neutral", PerfilIA.Dificultad.DIFICIL), senas, rng)
	gut.p("con «tengo el 2»: %.2f (%s); con «nada»: %.2f (%s)" % [resultados.cejas.p_mano, resultados.cejas.accion,
		resultados.ojos_cerrados.p_mano, resultados.ojos_cerrados.accion])
	assert_gt(resultados.cejas.p_mano, resultados.ojos_cerrados.p_mano + 0.2)
	assert_eq(resultados.cejas.accion.tipo, T.TRUCO, "con el 2 del compañero, grita truco")
	assert_eq(resultados.ojos_cerrados.accion.tipo, T.JUGAR_CARTA, "sin nada, juega sin gritar")


## Los rivales solo usan las señas que vieron: una seña que no vieron no cambia
## nada de lo que deciden.
func test_44_una_sena_no_vista_no_cambia_nada() -> void:
	var manos: Array[String] = ["2O 6C 4B", "7E 5E 1B", "6O 12E 5B", "3E 11C 10B"]
	var r := Escenario.construir("3O", manos, [H.carta(0, "4B")] as Array[Accion])
	var con := RegistroSenas.new()
	con.hechas = [{"emisor": 0, "sena": "cejas", "vieron": [2]}] as Array[Dictionary]
	var rng_a := RandomNumberGenerator.new()
	var rng_b := RandomNumberGenerator.new()
	rng_a.seed = 3
	rng_b.seed = 3
	var perfil := PerfilIA.crear("neutral", PerfilIA.Dificultad.DIFICIL)
	var da := IaMuestreo.decidir_con_detalle(Vista.para(r.mano, 1, con), perfil, senas, rng_a)
	var db := IaMuestreo.decidir_con_detalle(Vista.para(r.mano, 1, RegistroSenas.new()), perfil, senas, rng_b)
	assert_eq(Vista.para(r.mano, 1, con).senas, [] as Array[Dictionary], "el rival no ve la seña")
	assert_eq(str(da.accion), str(db.accion))
	assert_eq(da.p_mano, db.p_mano)


## T-10: el asistente da la misma sugerencia con la misma información pública,
## aunque cambien las cartas ocultas de los rivales.
func test_T10_el_asistente_no_usa_cartas_ocultas() -> void:
	var previas: Array[Accion] = []
	var a := Escenario.construir("1C", ["7O 6O 3B", "7E 5E 2B", "12O 4E 1B", "6B 3E 11O"], previas)
	var b := Escenario.construir("1C", ["7O 6O 3B", "2C 4C 1E", "12O 4E 1B", "5C 7B 10E"], previas)
	var sa := Asistente.sugerir(Vista.para(a.mano, 0), senas, 4)
	var sb := Asistente.sugerir(Vista.para(b.mano, 0), senas, 4)
	gut.p("sugerencia: %s" % sa.texto)
	assert_eq(sa.texto, sb.texto)
	assert_eq(str(sa.accion), str(sb.accion))
	assert_true(Vista.para(a.mano, 0).acciones_validas.any(func(x: Accion) -> bool: return x.es_igual(sa.accion)), "sugiere algo legal")


func test_44_controlador_senas_iniciales_y_de_la_persona() -> void:
	var c := ControladorMesa.new()
	c.automatico = false
	add_child_autofree(c)
	watch_signals(c)
	c.iniciar(21)
	var del_companero := c.registro.hechas.filter(func(s: Dictionary) -> bool: return s.emisor == 2)
	assert_false(del_companero.is_empty(), "el compañero hizo su seña al empezar")
	assert_signal_emitted(c, "sena_vista", "la persona ve la seña de su compañero")
	assert_true(c.hacer_sena("labio"))
	var mia: Dictionary = c.registro.hechas.back()
	assert_eq(mia.emisor, 0)
	assert_true(2 in mia.vieron, "el compañero ve siempre la seña de la persona")
	assert_false(c.hacer_sena("inexistente"))
