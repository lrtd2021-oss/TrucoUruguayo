extends GutTest
## Casos R-18 y R-60 a R-66: turnos, acciones permitidas, información y
## reproducibilidad. También la construcción de escenarios (tarea 2.11).

const H := preload("res://pruebas/ayuda.gd")
const SIN_FLOR: Array[String] = ["7O 6O 3B", "7E 5E 2B", "12O 4E 1B", "6B 3E 11O"]
const T := Accion.Tipo


func test_R18_la_muestra_nunca_esta_en_una_mano() -> void:
	var p := Partido.new(Reglamento.new(), 7)
	for i: int in 300:
		var m := p.nueva_mano()
		for j: int in 4:
			assert_false(m.iniciales_de(j).has(m.muestra.carta))
		p.repartidor = (p.repartidor + 1) % 4


func test_R60_no_se_juega_fuera_de_turno() -> void:
	var m := Escenario.mano("1C", SIN_FLOR)
	var antes := m.a_diccionario()
	var r := m.aplicar(H.carta(1, "7E"))
	assert_false(r.ok)
	assert_eq(r.error, "no le toca a este jugador")
	assert_eq(m.a_diccionario(), antes)


func test_R61_con_canto_pendiente_solo_respuestas() -> void:
	var m := Escenario.mano("1C", SIN_FLOR)
	assert_eq(H.aplicar(m, [H.a(T.ENVIDO, 0)]), "")
	assert_false(m.aplicar(H.carta(1, "7E")).ok, "no puede jugar")
	assert_false(m.aplicar(H.a(T.TRUCO, 1)).ok, "no puede gritar truco sobre un envido")
	assert_false(m.aplicar(H.carta(0, "3B")).ok, "el que cantó tampoco puede jugar")
	var tipos := H.tipos(m.acciones_validas(1))
	tipos.sort()
	assert_eq(tipos, [T.ENVIDO, T.REAL_ENVIDO, T.FALTA_ENVIDO, T.QUIERO, T.NO_QUIERO] as Array[int])


func test_R62_sin_envido_en_la_segunda_baza() -> void:
	var m := Escenario.mano("1C", SIN_FLOR)
	assert_eq(H.aplicar(m, [H.carta(0, "3B"), H.carta(1, "2B"), H.carta(2, "1B"), H.carta(3, "3E")]), "")
	assert_eq(m.baza, 1)
	assert_false(H.tipos(m.acciones_validas(m.actor())).has(T.ENVIDO))


func test_R63_la_flor_se_declara_antes_de_jugar() -> void:
	var m := Escenario.mano("1C", ["7O 6O 3O", "7E 5E 2B", "12O 4E 1B", "6B 3E 11O"] as Array[String])
	assert_eq(H.tipos(m.acciones_validas(0)), [T.CANTAR_FLOR] as Array[int])
	assert_false(m.aplicar(H.carta(0, "3O")).ok)
	assert_eq(H.aplicar(m, [H.a(T.CANTAR_FLOR, 0), H.carta(0, "3O")]), "")


func test_R64_una_accion_repetida_no_cambia_el_estado() -> void:
	var m := Escenario.mano("1C", SIN_FLOR)
	assert_true(m.aplicar(H.carta(0, "3B")).ok)
	var antes := m.a_diccionario()
	assert_false(m.aplicar(H.carta(0, "3B")).ok, "el segundo clic se rechaza")
	assert_eq(m.a_diccionario(), antes)


func test_R65_la_vista_no_contiene_cartas_ocultas() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 99
	var p := Partido.new(Reglamento.new(), 99)
	for i: int in 50:
		var m := p.nueva_mano()
		while m.fase != Mano.Fase.TERMINADA:
			for j: int in 4:
				var v := Vista.para(m, j)
				assert_eq(v.mis_cartas, m.cartas_de(j))
				var visibles := v.cartas_visibles()
				for otro: int in 4:
					if otro != j:
						for c: int in m.cartas_de(otro):
							assert_false(visibles.has(c), "el %d no ve la carta oculta del %d" % [j, otro])
			m.aplicar(IaAleatoria.decidir(Vista.para(m, m.actor()), rng))
		p.cerrar_mano()
		if p.ganador >= 0:
			p = Partido.new(Reglamento.new(), 99 + i)


func test_R66_misma_semilla_mismo_reparto() -> void:
	var a := Partido.new(Reglamento.new(), 1234).nueva_mano()
	var b := Partido.new(Reglamento.new(), 1234).nueva_mano()
	var c := Partido.new(Reglamento.new(), 4321).nueva_mano()
	assert_eq(a.muestra.carta, b.muestra.carta)
	assert_eq(a.iniciales, b.iniciales)
	assert_ne(a.iniciales, c.iniciales, "otra semilla da otro reparto")


func test_escenario_ilegal_no_se_construye() -> void:
	var r := Escenario.construir("1C", SIN_FLOR, [H.carta(0, "3B"), H.carta(0, "6O")] as Array[Accion])
	assert_null(r.mano)
	assert_string_contains(r.error, "acción 1")
	r = Escenario.construir("1C", SIN_FLOR, [H.carta(0, "3B"), H.carta(1, "2B")] as Array[Accion])
	assert_not_null(r.mano)
