extends GutTest
## Casos R-01 a R-07 del reglamento: baraja, piezas, alcahuete y jerarquía.

const ORDEN_COMPLETO: Array[String] = [
	# Reglamento, punto 4, con muestra 3O: de mayor a menor, por grupos que empatan.
	"2O", "4O", "5O", "11O", "10O", "1E", "1B", "7E", "7O",
	"3C|3E|3B", "2C|2E|2B", "1C|1O", "12O|12C|12E|12B", "11C|11E|11B",
	"10C|10E|10B", "7C|7B", "6O|6C|6E|6B", "5C|5E|5B", "4C|4E|4B",
]


func _c(t: String) -> int:
	return Carta.desde_texto(t)


func test_R01_baraja_de_40_sin_8_ni_9() -> void:
	var mazo := Carta.mazo()
	assert_eq(mazo.size(), 40)
	var textos := {}
	for c: int in mazo:
		textos[Carta.texto(c)] = true
		assert_false(Carta.numero(c) in [8, 9], "no hay 8 ni 9")
		assert_eq(Carta.desde_texto(Carta.texto(c)), c, "ida y vuelta de la notación")
	assert_eq(textos.size(), 40, "sin duplicados")


func test_R02_piezas_con_muestra_comun() -> void:
	var m := Muestra.new(_c("3O"))
	assert_false(m.alcahuete_activo)
	var piezas: Array[String] = ["2O", "4O", "5O", "11O", "10O"]
	for i: int in piezas.size():
		assert_eq(m.orden_pieza(_c(piezas[i])), i + 1, piezas[i])
	assert_eq(m.orden_pieza(_c("12O")), 0, "el 12 es un rey común")
	assert_eq(m.valor_tanto(_c("12O")), 0)


func test_R03_alcahuete_con_muestra_pieza() -> void:
	var m := Muestra.new(_c("4O"))
	assert_true(m.alcahuete_activo)
	assert_eq(m.orden_pieza(_c("12O")), 2, "el alcahuete toma el lugar del 4")
	assert_eq(m.valor_tanto(_c("12O")), 29)
	assert_eq(m.poder(_c("12O")), m.poder(_c("2O")) - 1, "segunda carta más alta")
	for t: String in ["2O", "5O", "11O", "10O"]:
		assert_gt(m.orden_pieza(_c(t)), 0, t + " sigue siendo pieza")
	assert_eq(m.orden_pieza(_c("4O")), 0, "la muestra no está en juego")


func test_R04_muestra_rey_sin_alcahuete() -> void:
	var m := Muestra.new(_c("12O"))
	assert_false(m.alcahuete_activo)
	var piezas: Array[String] = ["2O", "4O", "5O", "11O", "10O"]
	for i: int in piezas.size():
		assert_eq(m.orden_pieza(_c(piezas[i])), i + 1)


func test_R05_orden_completo_de_las_40() -> void:
	var m := Muestra.new(_c("3O"))
	var anterior := 1000
	var vistas := 0
	for grupo: String in ORDEN_COMPLETO:
		var cartas := grupo.split("|")
		var p := m.poder(_c(cartas[0]))
		assert_lt(p, anterior, "el grupo %s es menor que el anterior" % grupo)
		for t: String in cartas:
			assert_eq(m.poder(_c(t)), p, t + " empata dentro de su grupo")
		anterior = p
		vistas += cartas.size()
	assert_eq(vistas, 39, "las 40 cartas menos la muestra")


func test_R06_matas_no_cambian_con_muestra_de_espadas() -> void:
	var m := Muestra.new(_c("3E"))
	assert_eq(m.orden_pieza(_c("1E")), 0)
	assert_eq(m.orden_pieza(_c("7E")), 0)
	assert_eq(m.grupo(_c("1E")), Muestra.Grupo.MATA)
	for c: int in Carta.mazo():
		if c != _c("2E") and c != m.carta:
			assert_gt(m.poder(_c("2E")), m.poder(c), "el 2E le gana a " + Carta.texto(c))


func test_R07_empates_de_grupo() -> void:
	var m := Muestra.new(_c("3O"))
	assert_eq(m.poder(_c("3C")), m.poder(_c("3E")))
	assert_eq(m.poder(_c("7C")), m.poder(_c("7B")))
	assert_eq(m.poder(_c("1C")), m.poder(_c("1O")))
