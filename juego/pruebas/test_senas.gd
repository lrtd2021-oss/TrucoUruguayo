extends GutTest
## Caso R-68 y la mecánica de las señas (Fase 4, tareas 4.3 y 4.4).

var perfil := PerfilSenas.cargar()


func _c(t: String) -> int:
	return Carta.desde_texto(t)


func test_R68_el_perfil_clasico_no_tiene_conflictos_con_ninguna_muestra() -> void:
	assert_eq(perfil.id, "clasico")
	assert_eq(perfil.senas.size(), 12)
	for c: int in Carta.mazo():
		assert_eq(perfil.conflictos(Muestra.new(c)), [] as Array[String], "muestra " + Carta.texto(c))


func test_R68_cada_sena_significa_lo_documentado() -> void:
	var m := Muestra.new(_c("3O"))
	assert_eq(perfil.cartas_de("cejas", m), [_c("2O")] as Array[int])
	assert_eq(perfil.cartas_de("beso", m), [_c("4O")] as Array[int])
	assert_eq(perfil.cartas_de("nariz", m), [_c("5O")] as Array[int])
	assert_eq(perfil.cartas_de("guino_derecho", m), [_c("11O")] as Array[int])
	assert_eq(perfil.cartas_de("guino_izquierdo", m), [_c("10O")] as Array[int])
	assert_eq(perfil.cartas_de("mueca_derecha", m), Carta.lista(["1E", "1B"]))
	assert_eq(perfil.cartas_de("mueca_izquierda", m), Carta.lista(["7O", "7E"]))
	assert_eq(perfil.cartas_de("labio", m).size(), 3, "los 3 menos la muestra")
	assert_eq(perfil.cartas_de("boca", m), Carta.lista(["2C", "2E", "2B"]), "los 2 que no son pieza")
	assert_eq(perfil.cartas_de("lengua", m), Carta.lista(["1O", "1C"]))
	assert_true(perfil.es_nada("ojos_cerrados"))
	assert_true(perfil.es_flor("cachetes"))


func test_R68_el_alcahuete_usa_la_sena_de_la_pieza_que_reemplaza() -> void:
	var m := Muestra.new(_c("4O"))
	assert_eq(perfil.sena_de_carta(_c("12O"), m), "beso")
	assert_eq(perfil.sena_de_carta(_c("4O"), m), "", "la muestra no está en juego")
	assert_eq(perfil.sena_de_carta(_c("12C"), m), "", "un rey común no tiene seña")


func test_44_el_companero_ve_siempre_y_los_rivales_segun_atencion() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 1
	var atencion: Array[float] = [0.5, 0.8, 0.5, 0.8]
	var disimulo: Array[float] = [0.5, 0.5, 0.5, 0.5]
	var vistas_rival := 0
	var vistas_companero := 0
	for i: int in 2000:
		var r := RegistroSenas.new()
		var s := r.hacer(0, "cejas", atencion, disimulo, rng)
		if 2 in s.vieron:
			vistas_companero += 1
		if 1 in s.vieron:
			vistas_rival += 1
	assert_eq(vistas_companero, 2000)
	assert_almost_eq(vistas_rival / 2000.0, 0.4, 0.04, "0,8 de atención x 0,5 de disimulo")


func test_44_cada_uno_conoce_solo_las_senas_que_hizo_o_vio() -> void:
	var r := RegistroSenas.new()
	r.hechas = [{"emisor": 1, "sena": "beso", "vieron": [3]}, {"emisor": 0, "sena": "labio", "vieron": [2]}] as Array[Dictionary]
	assert_eq(r.conocidas_por(0).size(), 1, "la propia")
	assert_eq(r.conocidas_por(2).size(), 1, "la del compañero")
	assert_eq(r.conocidas_por(3).size(), 1, "la que vio del rival")
	assert_eq(r.conocidas_por(1).size(), 1, "la propia")
