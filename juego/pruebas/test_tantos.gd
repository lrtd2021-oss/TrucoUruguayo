extends GutTest
## Casos R-10 a R-17 (envido) y R-20 a R-25 (flor) del reglamento.


func _envido(muestra: String, mano: Array[String]) -> int:
	return Tantos.envido(Carta.lista(mano), Muestra.new(Carta.desde_texto(muestra)))


func _flor(muestra: String, mano: Array[String]) -> int:
	var m := Muestra.new(Carta.desde_texto(muestra))
	var cartas := Carta.lista(mano)
	return Tantos.valor_flor(cartas, m) if Tantos.tiene_flor(cartas, m) else -1


func test_R10_pieza_mas_la_mejor() -> void:
	assert_eq(_envido("3O", ["4O", "3B", "6C"]), 35)


func test_R11_dos_del_mismo_palo() -> void:
	assert_eq(_envido("3O", ["7E", "3E", "6O"]), 30)


func test_R12_tres_palos_distintos() -> void:
	assert_eq(_envido("3O", ["6B", "3C", "12E"]), 6)


func test_R13_pieza_y_as() -> void:
	assert_eq(_envido("3O", ["4O", "1B", "1O"]), 30)


func test_R14_maximo() -> void:
	assert_eq(_envido("3O", ["2O", "7C", "12B"]), 37)


func test_R15_alcahuete() -> void:
	assert_eq(_envido("4O", ["12O", "7E", "5C"]), 36)


func test_R16_solo_figuras() -> void:
	assert_eq(_envido("3O", ["12C", "11E", "10B"]), 0)


func test_R17_figuras_del_mismo_palo() -> void:
	assert_eq(_envido("3O", ["10C", "11C", "5E"]), 20)


func test_desglose_explica_la_cuenta() -> void:
	var m := Muestra.new(Carta.desde_texto("3O"))
	var d := Tantos.desglose_envido(Carta.lista(["4O", "3B", "6C"]), m)
	assert_eq(d.partes, [[Carta.desde_texto("4O"), 29], [Carta.desde_texto("6C"), 6]])
	assert_false(d.veinte)
	d = Tantos.desglose_envido(Carta.lista(["7E", "3E", "6O"]), m)
	assert_true(d.veinte)
	d = Tantos.desglose_flor(Carta.lista(["2O", "10O", "12C"]), m)
	assert_eq(d.partes, [[Carta.desde_texto("2O"), 30], [Carta.desde_texto("10O"), 7], [Carta.desde_texto("12C"), 0]])


## Tarea 2.11: en todos los ejemplos del reglamento, el desglose da el mismo
## valor que el cálculo y la suma de sus partes cierra.
func test_desgloses_cierran_en_los_ejemplos() -> void:
	var casos := [
		["3O", ["4O", "3B", "6C"]], ["3O", ["7E", "3E", "6O"]], ["3O", ["6B", "3C", "12E"]],
		["3O", ["4O", "1B", "1O"]], ["3O", ["2O", "7C", "12B"]], ["4O", ["12O", "7E", "5C"]],
		["3O", ["12C", "11E", "10B"]], ["3O", ["10C", "11C", "5E"]], ["3O", ["7B", "6B", "3B"]],
		["3O", ["2O", "4O", "5O"]], ["3O", ["2O", "10O", "12C"]], ["3O", ["5O", "7C", "6C"]],
		["4O", ["12O", "2O", "1E"]],
	]
	for caso: Array in casos:
		var m := Muestra.new(Carta.desde_texto(caso[0]))
		var nombres: Array[String] = []
		nombres.assign(caso[1])
		var cartas := Carta.lista(nombres)
		var d := Tantos.desglose_flor(cartas, m) if Tantos.tiene_flor(cartas, m) else Tantos.desglose_envido(cartas, m)
		var suma := 20 if d.veinte else 0
		for p: Array in d.partes:
			assert_true(cartas.has(p[0]), "la parte usa una carta de la mano")
			suma += p[1]
		assert_eq(suma, d.valor, str(caso))


func test_R20_flor_sin_piezas() -> void:
	assert_eq(_flor("3O", ["7B", "6B", "3B"]), 36)


func test_R21_flor_maxima() -> void:
	assert_eq(_flor("3O", ["2O", "4O", "5O"]), 47)


func test_R22_dos_piezas() -> void:
	assert_eq(_flor("3O", ["2O", "10O", "12C"]), 37)


func test_R23_pieza_y_dos_del_mismo_palo() -> void:
	assert_eq(_flor("3O", ["5O", "7C", "6C"]), 41)


func test_R24_sin_flor() -> void:
	assert_eq(_flor("3O", ["4O", "3B", "6C"]), -1)


func test_R25_flor_con_alcahuete() -> void:
	assert_eq(_flor("4O", ["12O", "2O", "1E"]), 40)
