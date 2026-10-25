extends GutTest
## Casos R-30 a R-36: quién gana cada baza, pardas y resolución de la mano.
## Asientos en orden de juego: 0 y 2 son la pareja A (equipo 0), 1 y 3 la B.
## Muestra 1C en todas: las piezas son 2C, 4C, 5C, 11C y 10C.

const H := preload("res://pruebas/ayuda.gd")


func _jugar(m: Mano, cartas: Array[String]) -> void:
	for t: String in cartas:
		var j := m.turno
		assert_eq(H.aplicar(m, [H.carta(j, t)]), "", "juega %s el jugador %d" % [t, j])


func test_R30_parda_entre_parejas() -> void:
	var m := Escenario.mano("1C", ["3O 12O 4B", "3E 12E 5B", "6B 11O 6O", "7C 11E 6E"])
	_jugar(m, ["3O", "3E", "6B", "7C"])
	assert_eq(m.resultados, [Mano.PARDA] as Array[int])


func test_R31_empate_dentro_de_la_pareja() -> void:
	var m := Escenario.mano("1C", ["3O 12O 4B", "6B 12E 5B", "3E 11O 6O", "7B 11E 6E"])
	_jugar(m, ["3O", "6B", "3E", "7B"])
	assert_eq(m.resultados, [0] as Array[int], "gana la pareja A")
	assert_eq(m.turno, 0, "abre la siguiente el primero que jugó la carta ganadora")


func test_R32_parda_en_primera_decide_la_segunda() -> void:
	var m := Escenario.mano("1C", ["3O 1E 12O", "3E 6O 12E", "4O 6E 12B", "4E 5O 11O"])
	_jugar(m, ["3O", "3E", "4O", "4E", "1E", "6O", "6E", "5O"])
	assert_eq(m.fase, Mano.Fase.TERMINADA)
	assert_eq(m.ganador_mano, 0)
	assert_eq(m.resultados.size(), 2, "la tercera no se juega")
	assert_eq(m.puntos, [1, 0] as Array[int])


func test_R33_una_y_una_y_parda_gana_la_primera() -> void:
	var m := Escenario.mano("1C", ["1E 5O 3O", "4O 1B 3E", "4E 5E 6O", "4B 5B 6E"])
	_jugar(m, ["1E", "4O", "4E", "4B", "5O", "1B", "5E", "5B", "3E", "6O", "6E", "3O"])
	assert_eq(m.resultados, [0, 1, Mano.PARDA] as Array[int])
	assert_eq(m.ganador_mano, 0)


func test_R34_parda_en_segunda_gana_la_primera() -> void:
	var m := Escenario.mano("1C", ["1E 3O 12O", "4O 3E 12E", "4E 5E 12B", "4B 5B 11O"])
	_jugar(m, ["1E", "4O", "4E", "4B", "3O", "3E", "5E", "5B"])
	assert_eq(m.ganador_mano, 0)
	assert_eq(m.resultados.size(), 2)


func test_R35_tres_pardas_gana_la_pareja_mano() -> void:
	# Reparte el 0, así que la mano es el jugador 1 (pareja B).
	var m := Escenario.mano("1C", ["6E 4E 5B", "3O 12O 7C", "3E 12E 7B", "6O 4B 5O"], 0)
	_jugar(m, ["3O", "3E", "6O", "6E", "12O", "12E", "4B", "4E", "7C", "7B", "5O", "5B"])
	assert_eq(m.resultados, [Mano.PARDA, Mano.PARDA, Mano.PARDA] as Array[int])
	assert_eq(m.ganador_mano, 1)


func test_R36_despues_de_una_parda_abre_el_mismo() -> void:
	var m := Escenario.mano("1C", ["6E 4E 5B", "6O 12O 7C", "3E 12E 7B", "3O 4O 6B"], 0)
	_jugar(m, ["6O", "3E", "3O", "6E"])
	assert_eq(m.resultados, [Mano.PARDA] as Array[int])
	assert_eq(m.turno, 1, "abre el que abrió la baza parda, no el de la carta más alta")
