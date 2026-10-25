extends GutTest
## Casos R-40 a R-55: envido, truco, flor, rechazos y fin del partido.
## Mano sin flor de referencia (muestra 1C): tantos 33, 32, 4 y 6.

const H := preload("res://pruebas/ayuda.gd")
const SIN_FLOR: Array[String] = ["7O 6O 3B", "7E 5E 2B", "12O 4E 1B", "6B 3E 11O"]
const T := Accion.Tipo


func _mano(manos: Array[String] = SIN_FLOR, puntos: Array[int] = [0, 0], repartidor := 3) -> Mano:
	return Escenario.mano("1C", manos, repartidor, puntos)


func test_R40_envido_no_querido() -> void:
	var m := _mano()
	assert_eq(H.aplicar(m, [H.a(T.ENVIDO, 0), H.a(T.NO_QUIERO, 1)]), "")
	assert_eq(m.puntos, [1, 0] as Array[int])
	assert_eq(m.fase, Mano.Fase.TURNO, "se sigue jugando la mano")


func test_R41_envido_envido_real_no_querido() -> void:
	var m := _mano()
	assert_eq(H.aplicar(m, [H.a(T.ENVIDO, 0), H.a(T.ENVIDO, 1), H.a(T.REAL_ENVIDO, 2), H.a(T.NO_QUIERO, 3)]), "")
	assert_eq(m.puntos, [4, 0] as Array[int])


func test_R42_envido_real_querido() -> void:
	var m := _mano()
	assert_eq(H.aplicar(m, [H.a(T.ENVIDO, 0), H.a(T.REAL_ENVIDO, 1), H.a(T.QUIERO, 2)]), "")
	assert_eq(m.puntos, [5, 0] as Array[int], "33 le gana a 32")
	var tipos: Array = m.historial.map(func(e: Dictionary) -> String: return e.tipo)
	assert_true(tipos.has("son_buenas"))
	assert_eq(m.mostrar, [0] as Array[int], "el ganador muestra sus cartas al final")


func test_R43_falta_envido_segun_el_puntero() -> void:
	var m := _mano(SIN_FLOR, [22, 10])
	assert_eq(H.aplicar(m, [H.a(T.FALTA_ENVIDO, 0), H.a(T.QUIERO, 1)]), "")
	assert_eq(m.puntos, [30, 10] as Array[int], "la falta vale 8 y gana el partido")
	assert_eq(m.ganador_partido, 0)
	var invertida: Array[String] = ["7E 5E 2B", "7O 6O 3B", "12O 4E 1B", "6B 3E 11O"]
	m = _mano(invertida, [22, 10])
	assert_eq(H.aplicar(m, [H.a(T.FALTA_ENVIDO, 0), H.a(T.QUIERO, 1)]), "")
	assert_eq(m.puntos, [22, 18] as Array[int], "la gana el que tenía 10: suma 8")


func test_R44_envido_y_falta_no_querida() -> void:
	var m := _mano()
	assert_eq(H.aplicar(m, [H.a(T.ENVIDO, 0), H.a(T.FALTA_ENVIDO, 1), H.a(T.NO_QUIERO, 2)]), "")
	assert_eq(m.puntos, [0, 2] as Array[int])


func test_R45_empate_de_tantos_gana_la_mano() -> void:
	var iguales: Array[String] = ["7O 6O 3B", "7E 6E 2B", "12O 4E 1B", "6B 3E 11O"]
	var m := _mano(iguales)
	assert_eq(H.aplicar(m, [H.a(T.ENVIDO, 0), H.a(T.QUIERO, 1)]), "")
	assert_eq(m.puntos, [2, 0] as Array[int], "mano el 0")
	m = _mano(iguales, [0, 0], 0)
	assert_eq(H.aplicar(m, [H.a(T.ENVIDO, 1), H.a(T.QUIERO, 2)]), "")
	assert_eq(m.puntos, [0, 2] as Array[int], "mano el 1")


func test_R46_truco_y_rechazos() -> void:
	var m := _mano()
	assert_eq(H.aplicar(m, [H.a(T.TRUCO, 0), H.a(T.NO_QUIERO, 1)]), "")
	assert_eq(m.puntos, [1, 0] as Array[int])
	assert_eq(m.fase, Mano.Fase.TERMINADA)
	m = _mano()
	assert_eq(H.aplicar(m, [H.a(T.TRUCO, 0), H.a(T.TRUCO, 1), H.a(T.NO_QUIERO, 2)]), "")
	assert_eq(m.puntos, [0, 2] as Array[int], "retruco no querido")
	m = _mano()
	assert_eq(H.aplicar(m, [H.a(T.TRUCO, 0), H.a(T.TRUCO, 1), H.a(T.TRUCO, 2), H.a(T.QUIERO, 3)]), "")
	assert_eq(m.truco_aceptado, 4)
	H.jugar_hasta_terminar(m)
	assert_eq(m.puntos[m.ganador_mano], 4, "vale cuatro querido")
	assert_eq(m.puntos[1 - m.ganador_mano], 0)


func test_R47_quien_canto_truco_no_puede_retrucar() -> void:
	var m := _mano()
	assert_eq(H.aplicar(m, [H.a(T.TRUCO, 0), H.a(T.QUIERO, 1)]), "")
	assert_false(H.tipos(m.acciones_validas(0)).has(T.TRUCO))
	assert_eq(H.aplicar(m, [H.carta(0, "3B")]), "")
	assert_true(H.tipos(m.acciones_validas(1)).has(T.TRUCO), "la pareja que quiso puede subir")


func test_R48_sin_envido_despues_de_querer_el_truco() -> void:
	var m := _mano()
	assert_eq(H.aplicar(m, [H.a(T.TRUCO, 0), H.a(T.QUIERO, 1)]), "")
	assert_false(H.tipos(m.acciones_validas(0)).has(T.ENVIDO))
	assert_eq(H.aplicar(m, [H.carta(0, "3B")]), "")
	assert_false(H.tipos(m.acciones_validas(1)).has(T.ENVIDO))


func test_R49_el_envido_esta_primero() -> void:
	var m := _mano()
	assert_eq(H.aplicar(m, [H.a(T.TRUCO, 0)]), "")
	assert_true(H.tipos(m.acciones_validas(1)).has(T.ENVIDO))
	assert_eq(H.aplicar(m, [H.a(T.ENVIDO, 1), H.a(T.QUIERO, 2)]), "")
	assert_eq(m.puntos, [2, 0] as Array[int], "se resuelve el envido")
	assert_eq(m.fase, Mano.Fase.CANTO, "y vuelve el truco")
	assert_eq(m.actor(), 1, "lo responde la pareja que lo recibió")
	assert_eq(H.aplicar(m, [H.a(T.QUIERO, 1)]), "")
	assert_eq(m.truco_aceptado, 2)


func test_R50_la_flor_anula_el_envido() -> void:
	var m := _mano(["7O 6O 3B", "7E 5E 2B", "12O 4E 1B", "7B 6B 4B"] as Array[String])
	assert_eq(H.aplicar(m, [H.a(T.ENVIDO, 0)]), "")
	assert_eq(m.actor(), 3, "quien tiene flor la declara antes de seguir")
	assert_eq(H.tipos(m.acciones_validas(3)), [T.CANTAR_FLOR] as Array[int])
	assert_eq(H.aplicar(m, [H.a(T.CANTAR_FLOR, 3)]), "")
	assert_true(m.envido_cerrado)
	assert_true(m.cantos.is_empty(), "el envido se anuló")
	assert_eq(m.puntos, [0, 0] as Array[int])
	H.jugar_hasta_terminar(m)
	assert_eq(m.historial.filter(func(e: Dictionary) -> bool: return e.tipo == "puntos" and e.motivo == "flor").size(), 1)


func test_R51_flor_sola_y_colleras() -> void:
	var m := _mano(["7O 6O 3B", "7E 5E 2B", "12O 4E 1B", "7B 6B 4B"] as Array[String])
	H.jugar_hasta_terminar(m)
	assert_eq(_puntos_por(m, "flor"), [0, 3])
	m = _mano(["7O 6O 3B", "7E 5E 2E", "12O 4E 1B", "7B 6B 4B"] as Array[String])
	H.jugar_hasta_terminar(m)
	assert_eq(_puntos_por(m, "flor"), [0, 6], "dos flores de la misma pareja")


func test_R52_flor_contra_flor() -> void:
	var m := _mano(["7O 6O 3O", "7E 5E 2E", "12O 4E 1B", "6B 3E 11O"] as Array[String])
	assert_eq(H.aplicar(m, [H.a(T.CANTAR_FLOR, 0), H.carta(0, "3O")]), "")
	assert_true(H.tipos(m.acciones_validas(1)).has(T.CON_FLOR_ME_ACHICO))
	assert_eq(H.aplicar(m, [H.a(T.CANTAR_FLOR, 1)]), "")
	assert_eq(m.actor(), 0, "la apuesta la responde quien tiene flor")
	assert_eq(H.aplicar(m, [H.a(T.QUIERO, 0)]), "")
	H.jugar_hasta_terminar(m)
	assert_eq(_puntos_por(m, "flor"), [6, 0], "36 le gana a 34")
	m = _mano(["7O 6O 3O", "7E 6E 3E", "12O 4E 1B", "6B 3B 11O"] as Array[String])
	assert_eq(H.aplicar(m, [H.a(T.CANTAR_FLOR, 0), H.carta(0, "3O"), H.a(T.CANTAR_FLOR, 1), H.a(T.QUIERO, 0)]), "")
	H.jugar_hasta_terminar(m)
	assert_eq(_puntos_por(m, "flor"), [6, 0], "empate: gana la más cercana a la mano")


func test_R53_contraflor_al_resto() -> void:
	var manos: Array[String] = ["7O 6O 3O", "7E 5E 2E", "12O 4E 1B", "6B 3E 11O"]
	var m := _mano(manos)
	assert_eq(H.aplicar(m, [H.a(T.CANTAR_FLOR, 0), H.carta(0, "3O"), H.a(T.CONTRAFLOR_AL_RESTO, 1), H.a(T.QUIERO, 0)]), "")
	H.jugar_hasta_terminar(m)
	assert_eq(m.puntos, [30, 0] as Array[int], "la mejor flor gana la falta")
	assert_eq(m.ganador_partido, 0)
	m = _mano(manos)
	assert_eq(H.aplicar(m, [H.a(T.CANTAR_FLOR, 0), H.carta(0, "3O"), H.a(T.CONTRAFLOR_AL_RESTO, 1), H.a(T.NO_QUIERO, 0)]), "")
	H.jugar_hasta_terminar(m)
	assert_eq(_puntos_por(m, "flor"), [0, 3], "no querida: 3 para quien la cantó")


func test_R54_mazo_con_truco_querido() -> void:
	var m := _mano()
	assert_eq(H.aplicar(m, [H.a(T.TRUCO, 0), H.a(T.QUIERO, 1), H.a(T.IR_AL_MAZO, 0)]), "")
	assert_eq(m.puntos, [0, 2] as Array[int])
	assert_eq(m.fase, Mano.Fase.TERMINADA)


func test_R55_ganar_un_envido_termina_el_partido() -> void:
	var m := _mano(SIN_FLOR, [28, 0])
	assert_eq(H.aplicar(m, [H.a(T.ENVIDO, 0), H.a(T.QUIERO, 1)]), "")
	assert_eq(m.puntos, [30, 0] as Array[int])
	assert_eq(m.ganador_partido, 0)
	assert_eq(m.fase, Mano.Fase.TERMINADA)
	assert_eq(m.mesa, [-1, -1, -1, -1] as Array[int], "no se jugó ninguna carta")
	assert_true(m.acciones_validas(0).is_empty())


func test_D15_decisor_fijo_responde_por_su_pareja() -> void:
	var m := _mano()
	m.decisor = [0, -1] as Array[int]
	assert_eq(H.aplicar(m, [H.carta(0, "3B"), H.a(T.TRUCO, 1)]), "")
	assert_eq(m.actor(), 0, "responde el asiento fijado, no el siguiente")


func _puntos_por(m: Mano, motivo: String) -> Array:
	var r := [0, 0]
	for e: Dictionary in m.historial:
		if e.tipo == "puntos" and e.motivo == motivo:
			r[e.equipo] += e.puntos
	return r
