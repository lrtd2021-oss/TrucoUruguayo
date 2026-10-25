extends GutTest
## Fase 3: controlador de la mesa y escena del prototipo.
## Tareas 3.2 (sin acciones duplicadas), 3.3 (botones desde las acciones
## válidas), 3.4 (partido completo desde la interfaz) y 3.5 (fuentes por
## asiento y pausa).

const F := ControladorMesa.Fuente


func _controlador(semilla := 11) -> ControladorMesa:
	var c := ControladorMesa.new()
	c.automatico = false
	add_child_autofree(c)
	c.iniciar(semilla)
	return c


## Avanza a la IA hasta que le toque a la persona o termine la mano.
func _hasta_turno_humano(c: ControladorMesa) -> void:
	var guarda := 0
	while not c.esperando_humano() and c.mano.fase != Mano.Fase.TERMINADA and guarda < 100:
		guarda += 1
		c.paso()


func _mesa(semilla: int) -> Mesa:
	var m := Mesa.new()
	m.velocidad = 0.0
	m.iniciar_al_cargar = false
	add_child_autofree(m)
	m.controlador.automatico = false
	m.empezar(semilla)
	return m


func test_32_un_clic_doble_aplica_una_sola_vez() -> void:
	var c := _controlador()
	_hasta_turno_humano(c)
	assert_true(c.esperando_humano())
	var a: Accion = c.mano.acciones_validas(0)[0]
	var antes := c.mano.historial.size()
	assert_true(c.solicitar(a))
	var despues := c.mano.historial.size()
	assert_gt(despues, antes)
	assert_false(c.solicitar(a), "el segundo clic se rechaza")
	assert_eq(c.mano.historial.size(), despues, "y no cambia nada")


func test_32_nada_se_aplica_mientras_se_anima() -> void:
	var c := _controlador()
	_hasta_turno_humano(c)
	c.esperar_presentacion = true
	var validas := c.mano.acciones_validas(0)
	assert_true(c.solicitar(validas[0]))
	assert_true(c.presentando)
	assert_false(c.paso(), "la IA espera a que termine la animación")
	var tamano := c.mano.historial.size()
	for a: Accion in c.mano.acciones_validas(c.actor()):
		assert_false(c.solicitar(a))
	assert_eq(c.mano.historial.size(), tamano)
	c.presentacion_terminada()
	assert_false(c.presentando)


func test_33_los_botones_salen_de_las_acciones_validas() -> void:
	for semilla: int in [3, 17, 42]:
		var m := _mesa(semilla)
		_hasta_turno_humano(m.controlador)
		if m.controlador.mano.fase == Mano.Fase.TERMINADA:
			continue
		var validas := m.controlador.mano.acciones_validas(0)
		var cartas_validas := validas.filter(func(a: Accion) -> bool: return a.tipo == Accion.Tipo.JUGAR_CARTA)
		assert_eq(m._acciones.get_child_count(), validas.size() - cartas_validas.size(), "un botón por acción que no es carta")
		var seleccionables := 0
		for carta: CartaVista in m._mano_propia.get_children():
			if carta.seleccionable:
				seleccionables += 1
				assert_true(cartas_validas.any(func(a: Accion) -> bool: return a.carta == carta.carta))
		assert_eq(seleccionables, cartas_validas.size(), "solo se pueden tocar las cartas jugables")
	await _sin_huerfanos()


func test_34_partido_completo_desde_la_interfaz() -> void:
	for semilla: int in 8:
		var m := _mesa(100 + semilla)
		var c := m.controlador
		var pasos := 0
		while c.partido.ganador < 0 and pasos < 5000:
			pasos += 1
			if c.esperando_humano():
				_tocar_algo(m)
			elif c.mano.fase == Mano.Fase.TERMINADA:
				assert_true(m._aviso.visible, "al terminar la mano aparece el aviso")
				m._al_cerrar_aviso()
			else:
				c.paso()
		assert_gt(c.partido.ganador, -1, "semilla %d: el partido terminó" % semilla)
		assert_eq(c.partido.puntos[c.partido.ganador], c.reglamento.objetivo)
		assert_true(m._aviso.visible, "aviso de fin de partido")
	await _sin_huerfanos()


## Los nodos que la interfaz descarta se liberan al final del cuadro: después
## de dejar pasar dos cuadros no tiene que quedar ninguno suelto (sin fugas).
func _sin_huerfanos() -> void:
	await wait_process_frames(2)
	assert_no_new_orphans("los nodos descartados por la interfaz se liberan")


## Toca la primera carta jugable o, si no hay, el primer botón, como haría
## la persona. Así la prueba pasa por la interfaz y no directo al motor.
func _tocar_algo(m: Mesa) -> void:
	for carta: CartaVista in m._mano_propia.get_children():
		if carta.seleccionable:
			carta.elegida.emit(carta.carta)
			return
	var botones := m._acciones.get_children()
	assert_false(botones.is_empty(), "si le toca a la persona, hay algo para tocar")
	if not botones.is_empty():
		(botones[0] as Button).pressed.emit()


func test_35_guion_por_asiento() -> void:
	var c := ControladorMesa.new()
	c.automatico = false
	c.fuentes = [F.GUION, F.GUION, F.GUION, F.GUION] as Array[int]
	add_child_autofree(c)
	c.iniciar(5)
	var j := c.actor()
	var primera: Accion = c.mano.acciones_validas(j)[0]
	c.guion = [primera] as Array[Accion]
	assert_true(c.paso(), "aplica la acción del guion")
	assert_eq(c.mano.acciones.back(), primera)
	watch_signals(c)
	c.guion = [Accion.new(Accion.Tipo.IR_AL_MAZO, (c.actor() + 1) % 4)] as Array[Accion]
	assert_false(c.paso(), "una acción ilegal del guion no se aplica")
	assert_signal_emitted(c, "error_guion")


func test_35_pausar_no_cambia_el_resultado() -> void:
	var a := ControladorMesa.new()
	var b := ControladorMesa.new()
	for c: ControladorMesa in [a, b]:
		c.automatico = false
		c.fuentes = [F.IA, F.IA, F.IA, F.IA] as Array[int]
		add_child_autofree(c)
		c.iniciar(77)
	var i := 0
	while a.partido.ganador < 0 and i < 3000:
		i += 1
		if a.mano.fase == Mano.Fase.TERMINADA:
			a.siguiente_mano()
		else:
			a.paso()
	i = 0
	while b.partido.ganador < 0 and i < 6000:
		i += 1
		if i % 3 == 0:
			b.pausar(true)
			assert_false(b.paso(), "en pausa no avanza")
			b.pausar(false)
		if b.mano.fase == Mano.Fase.TERMINADA:
			b.siguiente_mano()
		else:
			b.paso()
	assert_eq(b.partido.puntos, a.partido.puntos, "mismo partido con y sin pausas")
	assert_eq(b.partido.manos_jugadas, a.partido.manos_jugadas)


func test_d15_la_persona_responde_por_su_pareja() -> void:
	var c := _controlador()
	assert_eq(c.partido.decisor, [0, -1] as Array[int])
	assert_eq(c.mano.decisor, [0, -1] as Array[int])

