class_name Mesa
extends Control
## Mesa del prototipo (Fase 3): muestra el partido con cartas provisionales,
## anima los eventos de a uno y arma los botones solo con las acciones válidas.
## No decide nada: todo pasa por el ControladorMesa.
##
## Argumentos de línea de comandos (después de --), para pruebas y capturas:
##   --semilla=N          reparto reproducible
##   --auto               el asiento 0 también lo juega la IA
##   --velocidad=X        multiplica la velocidad de las animaciones
##   --resolucion=AxB     tamaño de la ventana
##   --captura=RUTA       guarda una captura PNG y cierra el juego
##   --capturar-tras=S    segundos antes de la captura (por defecto 6)
##   --probar-clics       envía clics de ratón reales a una carta y a un botón,
##                        comprueba que llegan al motor y sale con 0 (bien) o 1

const ASIENTO_PERSONA := 0
const NOMBRES: Array[String] = ["Vos", "Cacho", "Tito", "Marta"]
const NOMBRE_EQUIPO: Array[String] = ["Nosotros", "Ellos"]
## Posición de la carta jugada de cada asiento, relativa al centro de la mesa.
const RANURA: Array[Vector2] = [Vector2(0, 120), Vector2(230, -20), Vector2(0, -170), Vector2(-230, -20)]
const COLOR_MESA := Color("2b3a2a")
const COLOR_PANEL := Color(0.08, 0.08, 0.07, 0.72)
const COLOR_TEXTO := Color("ede6d6")
const COLOR_ACENTO := Color("c8963e")

var controlador := ControladorMesa.new()
## Multiplicador de velocidad de las animaciones. 0 las saltea (pruebas).
var velocidad := 1.0
## Las pruebas lo apagan para configurar el controlador antes de empezar.
var iniciar_al_cargar := true

var _centro := Control.new()
var _mano_propia := HBoxContainer.new()
var _acciones := VBoxContainer.new()
var _registro := RichTextLabel.new()
var _tanteador := Label.new()
var _bazas := Label.new()
var _valor_mano := Label.new()
var _muestra_carta := CartaVista.new()
var _muestra_texto := Label.new()
var _asientos: Array[Label] = []
var _dorsos: Array[HBoxContainer] = []
var _globos: Array[Label] = []
var _aviso := PanelContainer.new()
var _aviso_texto := Label.new()
var _aviso_boton := Button.new()
var _pausa := ColorRect.new()
var _menu_senas := PopupMenu.new()

var _cola: Array[Dictionary] = []
var _procesando := false
var _en_mesa: Array[CartaVista] = []
var _ultimo_canto := ""
var _muestra: Muestra
var _args := {}


func _ready() -> void:
	_leer_argumentos()
	_construir()
	add_child(controlador)
	controlador.esperar_presentacion = true
	controlador.eventos_aplicados.connect(_al_recibir_eventos)
	controlador.espera_humano.connect(func(_j: int) -> void: _refrescar())
	controlador.sena_vista.connect(_al_ver_sena)
	if _args.has("auto"):
		controlador.fuentes[ASIENTO_PERSONA] = ControladorMesa.Fuente.IA
	if iniciar_al_cargar:
		empezar(int(_args.get("semilla", Time.get_ticks_usec() % 100000)))
	if _args.has("captura"):
		_capturar_despues(float(_args.get("capturar-tras", "6")), String(_args.captura))
	if _args.has("probar-clics"):
		_probar_clics()


func empezar(semilla: int) -> void:
	_registro.clear()
	controlador.iniciar(semilla)


# --- Construcción de la interfaz ---------------------------------------------

func _construir() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var fondo := ColorRect.new()
	fondo.color = COLOR_MESA
	fondo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(fondo)
	fondo.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	add_child(_centro)
	_centro.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	_centro.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var presets: Array[int] = [Control.PRESET_BOTTOM_LEFT, Control.PRESET_CENTER_RIGHT, Control.PRESET_CENTER_TOP, Control.PRESET_CENTER_LEFT]
	var desplazamientos: Array[Vector2] = [Vector2(40, -300), Vector2(-640, -60), Vector2(-150, 24), Vector2(40, -60)]
	for j: int in Mano.JUGADORES:
		var caja := VBoxContainer.new()
		add_child(caja)
		caja.set_anchors_and_offsets_preset(presets[j])
		caja.position += desplazamientos[j]
		var etiqueta := _etiqueta("", 24)
		caja.add_child(etiqueta)
		_asientos.append(etiqueta)
		var dorsos := HBoxContainer.new()
		dorsos.add_theme_constant_override("separation", -20)
		caja.add_child(dorsos)
		_dorsos.append(dorsos)
		var globo := _etiqueta("", 30)
		globo.add_theme_stylebox_override("normal", _estilo(COLOR_TEXTO, COLOR_ACENTO))
		globo.add_theme_color_override("font_color", Color("1e1e1c"))
		globo.modulate.a = 0.0
		caja.add_child(globo)
		_globos.append(globo)

	add_child(_mano_propia)
	_mano_propia.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	_mano_propia.offset_top = -220
	_mano_propia.offset_bottom = -40
	_mano_propia.alignment = BoxContainer.ALIGNMENT_CENTER
	_mano_propia.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_mano_propia.add_theme_constant_override("separation", 20)

	var muestra := VBoxContainer.new()
	add_child(muestra)
	muestra.position = Vector2(30, 24)
	muestra.add_child(_etiqueta("Muestra", 22))
	muestra.add_child(_muestra_carta)
	_muestra_texto.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_muestra_texto.custom_minimum_size = Vector2(300, 0)
	_muestra_texto.add_theme_font_size_override("font_size", 18)
	_muestra_texto.add_theme_color_override("font_color", COLOR_TEXTO)
	muestra.add_child(_muestra_texto)

	var panel := _panel_lateral(Vector2(-400, 24), Vector2(370, 250))
	for etiqueta: Label in [_tanteador, _bazas, _valor_mano]:
		etiqueta.add_theme_color_override("font_color", COLOR_TEXTO)
		panel.add_child(etiqueta)
	_tanteador.add_theme_font_size_override("font_size", 26)
	_bazas.add_theme_font_size_override("font_size", 20)
	_valor_mano.add_theme_font_size_override("font_size", 20)

	var registro := _panel_lateral(Vector2(-400, 290), Vector2(370, 360))
	_registro.bbcode_enabled = true
	_registro.scroll_following = true
	_registro.custom_minimum_size = Vector2(350, 340)
	_registro.add_theme_font_size_override("normal_font_size", 17)
	registro.add_child(_registro)

	add_child(_acciones)
	_acciones.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	_acciones.position += Vector2(-330, -380)
	_acciones.custom_minimum_size = Vector2(300, 0)
	_acciones.add_theme_constant_override("separation", 10)

	add_child(_aviso)
	_aviso.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	_aviso.add_theme_stylebox_override("panel", _estilo(Color(0.08, 0.08, 0.07, 0.92), COLOR_ACENTO))
	var caja_aviso := VBoxContainer.new()
	caja_aviso.add_theme_constant_override("separation", 16)
	_aviso.add_child(caja_aviso)
	_aviso_texto.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_aviso_texto.add_theme_font_size_override("font_size", 28)
	_aviso_texto.add_theme_color_override("font_color", COLOR_TEXTO)
	caja_aviso.add_child(_aviso_texto)
	_aviso_boton.add_theme_font_size_override("font_size", 24)
	_aviso_boton.pressed.connect(_al_cerrar_aviso)
	caja_aviso.add_child(_aviso_boton)
	_aviso.visible = false

	add_child(_menu_senas)
	_menu_senas.add_theme_font_size_override("font_size", 22)
	_menu_senas.id_pressed.connect(_al_elegir_sena)

	add_child(_pausa)
	_pausa.color = Color(0, 0, 0, 0.6)
	_pausa.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var texto_pausa := _etiqueta("Pausa\n\nP o Esc para seguir", 40)
	texto_pausa.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	texto_pausa.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_pausa.add_child(texto_pausa)
	texto_pausa.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_pausa.visible = false


func _panel_lateral(desplazamiento: Vector2, tamano: Vector2) -> VBoxContainer:
	var panel := PanelContainer.new()
	add_child(panel)
	panel.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	panel.position += desplazamiento
	panel.custom_minimum_size = tamano
	panel.add_theme_stylebox_override("panel", _estilo(COLOR_PANEL, Color(1, 1, 1, 0.08)))
	var caja := VBoxContainer.new()
	panel.add_child(caja)
	return caja


func _etiqueta(texto: String, tamano: int) -> Label:
	var l := Label.new()
	l.text = texto
	l.add_theme_font_size_override("font_size", tamano)
	l.add_theme_color_override("font_color", COLOR_TEXTO)
	return l


func _estilo(fondo: Color, borde: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = fondo
	s.border_color = borde
	s.set_border_width_all(2)
	s.set_corner_radius_all(8)
	s.set_content_margin_all(12)
	return s


# --- Presentación de eventos -------------------------------------------------

func _al_recibir_eventos(eventos: Array[Dictionary]) -> void:
	_cola.append_array(eventos)
	if not _procesando:
		_procesar_cola()


func _procesar_cola() -> void:
	_procesando = true
	_deshabilitar()
	while not _cola.is_empty():
		var e: Dictionary = _cola.pop_front()
		await _mostrar(e)
	_procesando = false
	_refrescar()
	controlador.presentacion_terminada()


func _mostrar(e: Dictionary) -> void:
	match e.tipo:
		"reparto":
			_preparar_mano(e)
			await _esperar(0.4)
		"carta":
			await _jugar_carta(e.jugador, e.carta)
		"baza":
			var r: int = e.resultado
			_anotar_registro("Baza %d.ª: %s" % [int(e.baza) + 1, "parda" if r == Mano.PARDA else "gana " + NOMBRES[e.jugador]])
			_actualizar_bazas()
			await _esperar(0.8)
			_limpiar_mesa()
		"canto":
			_ultimo_canto = e.canto
			await _decir(e.jugador, "¡%s!" % Textos.mayuscula(e.canto))
		"flor":
			_ultimo_canto = "flor"
			await _decir(e.jugador, "¡Flor!")
		"respuesta":
			var flor := _ultimo_canto.contains("flor")
			var texto := ("Con flor quiero" if flor else "Quiero") if e.quiero else ("Con flor me achico" if flor else "No quiero")
			await _decir(e.jugador, texto)
		"tanto":
			await _decir(e.jugador, str(e.tanto))
		"son_buenas":
			await _decir(e.jugador, "Son buenas")
		"valor_flor":
			await _decir(e.jugador, "Flor de %d" % int(e.flor))
		"envido_anulado":
			_anotar_registro("La flor anula el envido.")
		"mazo":
			await _decir(e.jugador, "Me voy al mazo")
		"puntos":
			_anotar_registro("[color=#c8963e]+%d para %s[/color] (%s)" % [int(e.puntos), NOMBRE_EQUIPO[e.equipo], e.motivo])
			_actualizar_tanteador(e.tanteador)
			await _esperar(0.4)
		"fin_mano":
			_fin_de_mano(e)
		"sena_vista":
			await _mostrar_sena(e.sena)


## Las señas no son eventos del motor: el controlador avisa solo las que la
## persona hizo o vio, y se muestran en la misma cola que el resto.
func _al_ver_sena(s: Dictionary) -> void:
	_al_recibir_eventos([{"tipo": "sena_vista", "sena": s}] as Array[Dictionary])


func _mostrar_sena(s: Dictionary) -> void:
	var emisor: int = s.emisor
	var datos := controlador.perfil_senas.sena(s.sena)
	var gesto: String = datos.gesto
	var texto := ""
	if emisor == ASIENTO_PERSONA:
		texto = "Le hacés una seña a %s: %s (%s)." % [NOMBRES[2], gesto, datos.significa]
	elif Mano.equipo(emisor) == Mano.equipo(ASIENTO_PERSONA):
		texto = "[b]%s te hace una seña:[/b] %s (%s)." % [NOMBRES[emisor], gesto, datos.significa]
	else:
		var companero := NOMBRES[(emisor + 2) % Mano.JUGADORES]
		texto = "Viste a %s hacerle una seña a %s: %s (%s)." % [NOMBRES[emisor], companero, gesto, datos.significa]
	_anotar_registro("[i]%s[/i]" % texto)
	var globo := _globos[emisor]
	globo.text = "(%s)" % gesto
	globo.modulate.a = 1.0
	if velocidad > 0.0:
		var t := create_tween()
		t.tween_interval(1.6 / velocidad)
		t.tween_property(globo, "modulate:a", 0.0, 0.4 / velocidad)
	await _esperar(0.5)


func _preparar_mano(e: Dictionary) -> void:
	_limpiar_mesa()
	_aviso.visible = false
	_muestra = Muestra.new(e.muestra)
	_muestra_carta.mostrar(e.muestra)
	var piezas := "Piezas: 2, 4, 5, 11 y 10 de %s." % CartaVista.NOMBRE_PALO[_muestra.palo].to_lower()
	if _muestra.alcahuete_activo:
		piezas += " El 12 es alcahuete: hace de %d." % Muestra.NUMEROS_PIEZA[_muestra.pieza_reemplazada - 1]
	_muestra_texto.text = piezas
	_anotar_registro("[b]Reparte %s.[/b] Es mano %s." % [NOMBRES[e.repartidor], NOMBRES[e.mano]])
	for j: int in Mano.JUGADORES:
		_asientos[j].text = _titulo_asiento(j)
	_vaciar(_mano_propia)
	for c: int in controlador.mano.iniciales_de(ASIENTO_PERSONA):
		var carta := CartaVista.new()
		carta.mostrar(c, _muestra)
		carta.elegida.connect(_al_elegir_carta)
		_mano_propia.add_child(carta)
	_actualizar_dorsos()
	_actualizar_bazas()
	_actualizar_tanteador(controlador.mano.puntos)


func _jugar_carta(j: int, c: int) -> void:
	var carta := CartaVista.new()
	carta.mostrar(c, _muestra)
	add_child(carta)
	var origen := _asientos[j].get_global_rect().get_center()
	if j == ASIENTO_PERSONA:
		for hijo: CartaVista in _mano_propia.get_children():
			if hijo.carta == c:
				origen = hijo.get_global_rect().get_center()
				hijo.queue_free()
	carta.global_position = origen - CartaVista.TAMANO / 2
	_en_mesa.append(carta)
	_actualizar_dorsos()
	var destino := _centro.global_position + RANURA[j] - CartaVista.TAMANO / 2
	if velocidad <= 0.0:
		carta.global_position = destino
		return
	var t := create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_property(carta, "global_position", destino, 0.3 / velocidad)
	t.parallel().tween_property(carta, "rotation", randf_range(-0.08, 0.08), 0.3 / velocidad)
	await t.finished


func _decir(j: int, texto: String) -> void:
	_anotar_registro("%s: «%s»" % [NOMBRES[j], texto])
	var globo := _globos[j]
	globo.text = texto
	globo.modulate.a = 1.0
	if velocidad > 0.0:
		var t := create_tween()
		t.tween_interval(1.4 / velocidad)
		t.tween_property(globo, "modulate:a", 0.0, 0.4 / velocidad)
	await _esperar(0.7)


func _fin_de_mano(e: Dictionary) -> void:
	for s: int in e.mostrar:
		var textos: Array[String] = []
		for c: int in e.mostrar[s]:
			textos.append(Carta.texto(c))
		_anotar_registro("%s muestra: %s" % [NOMBRES[s], ", ".join(textos)])
	var g: int = e.ganador_partido
	if g >= 0:
		_aviso_texto.text = "¡Ganaron el partido!" if g == Mano.equipo(ASIENTO_PERSONA) else "Perdieron el partido."
		_aviso_texto.text += "\n%s %d - %s %d" % [NOMBRE_EQUIPO[0], controlador.partido.puntos[0], NOMBRE_EQUIPO[1], controlador.partido.puntos[1]]
		_aviso_boton.text = "Jugar otro partido (Enter)"
	else:
		var gm: int = e.ganador_mano
		_aviso_texto.text = "Mano para %s." % NOMBRE_EQUIPO[gm].to_lower()
		_aviso_boton.text = "Siguiente mano (Enter)"
	_aviso.visible = true
	_aviso.reset_size()
	_aviso.position = (size - _aviso.size) / 2
	if _args.has("auto"):
		get_tree().create_timer(1.0).timeout.connect(_al_cerrar_aviso)


func _al_cerrar_aviso() -> void:
	if not _aviso.visible or _procesando:
		return
	_aviso.visible = false
	if controlador.partido.ganador >= 0:
		empezar(controlador.partido.rng.randi())
	else:
		controlador.siguiente_mano()


func _esperar(segundos: float) -> void:
	if velocidad > 0.0:
		await get_tree().create_timer(segundos / velocidad).timeout


# --- Estado visible --------------------------------------------------------

func _titulo_asiento(j: int) -> String:
	var marca := " · mano" if controlador.mano and controlador.mano.jugador_mano == j else ""
	if j == ASIENTO_PERSONA:
		return NOMBRES[j] + marca
	var rol := "compañero" if Mano.equipo(j) == Mano.equipo(ASIENTO_PERSONA) else "rival"
	return "%s (%s)%s" % [NOMBRES[j], rol, marca]


func _actualizar_dorsos() -> void:
	for j: int in Mano.JUGADORES:
		var fila := _dorsos[j]
		_vaciar(fila)
		if j == ASIENTO_PERSONA:
			continue
		for i: int in controlador.mano.cartas_de(j).size():
			# Los contenedores anulan la escala de sus hijos: el dorso achicado va
			# dentro de un Control común del tamaño reducido.
			var lugar := Control.new()
			lugar.custom_minimum_size = CartaVista.TAMANO * 0.5
			var dorso := CartaVista.new()
			dorso.dorso()
			dorso.pivot_offset = Vector2.ZERO
			dorso.scale = Vector2(0.5, 0.5)
			lugar.add_child(dorso)
			fila.add_child(lugar)


func _actualizar_tanteador(puntos: Array) -> void:
	var malas := controlador.reglamento.malas()
	var lineas: Array[String] = []
	for e: int in 2:
		var p: int = puntos[e]
		var etapa := "malas" if p < malas else "buenas: %d" % (p - malas)
		lineas.append("%s  %d  (%s)" % [NOMBRE_EQUIPO[e], p, etapa])
	_tanteador.text = "\n".join(lineas) + "\nA %d puntos" % controlador.reglamento.objetivo


func _actualizar_bazas() -> void:
	var m := controlador.mano
	var partes: Array[String] = []
	for i: int in 3:
		var texto := "—"
		if i < m.resultados.size():
			var r := m.resultados[i]
			texto = "parda" if r == Mano.PARDA else ("ganada" if r == Mano.equipo(ASIENTO_PERSONA) else "perdida")
		partes.append("%d.ª %s" % [i + 1, texto])
	_bazas.text = "Bazas: " + " · ".join(partes)
	var valor := m.truco_aceptado
	_valor_mano.text = "La mano vale %d %s" % [valor, "punto" if valor == 1 else "puntos"]


func _limpiar_mesa() -> void:
	for carta: CartaVista in _en_mesa:
		carta.queue_free()
	_en_mesa.clear()


func _anotar_registro(texto: String) -> void:
	_registro.append_text(texto + "\n")


static func _vaciar(nodo: Node) -> void:
	for hijo: Node in nodo.get_children():
		nodo.remove_child(hijo)
		hijo.queue_free()


# --- Entrada de la persona ---------------------------------------------------

func _refrescar() -> void:
	_deshabilitar()
	if controlador.mano == null:
		return
	var actor := controlador.actor()
	for j: int in Mano.JUGADORES:
		_asientos[j].text = ("▶ " if j == actor else "") + _titulo_asiento(j)
		_asientos[j].add_theme_color_override("font_color", COLOR_ACENTO if j == actor else COLOR_TEXTO)
	_actualizar_bazas()
	if _procesando or not controlador.esperando_humano():
		return
	var v := Vista.para(controlador.mano, ASIENTO_PERSONA)
	var boton_senas := Button.new()
	boton_senas.name = "BotonSenas"
	boton_senas.text = "Hacer una seña… (S)"
	boton_senas.custom_minimum_size = Vector2(300, 44)
	boton_senas.add_theme_font_size_override("font_size", 20)
	boton_senas.pressed.connect(_abrir_menu_senas)
	_acciones.add_child(boton_senas)
	for a: Accion in v.acciones_validas:
		if a.tipo == Accion.Tipo.JUGAR_CARTA:
			for carta: CartaVista in _mano_propia.get_children():
				if carta.carta == a.carta:
					carta.seleccionable = true
		else:
			var boton := Button.new()
			boton.text = Textos.accion(a, v)
			boton.custom_minimum_size = Vector2(300, 52)
			boton.add_theme_font_size_override("font_size", 22)
			boton.pressed.connect(_pedir.bind(a))
			_acciones.add_child(boton)


func _deshabilitar() -> void:
	_vaciar(_acciones)
	for carta: CartaVista in _mano_propia.get_children():
		carta.seleccionable = false


func _pedir(a: Accion) -> void:
	_deshabilitar()
	if not controlador.solicitar(a):
		_refrescar()


func _abrir_menu_senas() -> void:
	if not controlador.esperando_humano():
		return
	_menu_senas.clear()
	var senas := controlador.perfil_senas.senas
	for i: int in senas.size():
		_menu_senas.add_item("%s (%s)" % [Textos.mayuscula(senas[i].gesto), senas[i].significa], i)
	_menu_senas.popup_centered()


func _al_elegir_sena(i: int) -> void:
	controlador.hacer_sena(controlador.perfil_senas.senas[i].id)


func _al_elegir_carta(c: int) -> void:
	_pedir(Accion.new(Accion.Tipo.JUGAR_CARTA, ASIENTO_PERSONA, c))


func _unhandled_input(event: InputEvent) -> void:
	var tecla := event as InputEventKey
	if tecla == null or not tecla.pressed or tecla.echo:
		return
	match tecla.keycode:
		KEY_P, KEY_ESCAPE:
			controlador.pausar(not controlador.pausado)
			_pausa.visible = controlador.pausado
			_refrescar()
		KEY_ENTER, KEY_KP_ENTER:
			_al_cerrar_aviso()
		KEY_S:
			_abrir_menu_senas()
		KEY_1, KEY_2, KEY_3:
			var i := int(tecla.keycode - KEY_1)
			var cartas := _mano_propia.get_children()
			if i < cartas.size() and (cartas[i] as CartaVista).seleccionable:
				_al_elegir_carta((cartas[i] as CartaVista).carta)


# --- Argumentos y capturas ---------------------------------------------------

func _leer_argumentos() -> void:
	for arg: String in OS.get_cmdline_user_args():
		var partes := arg.trim_prefix("--").split("=", true, 1)
		_args[partes[0]] = partes[1] if partes.size() > 1 else ""
	if _args.has("velocidad"):
		velocidad = float(_args.velocidad)
	if _args.has("resolucion"):
		var r := String(_args.resolucion).split("x")
		DisplayServer.window_set_size(Vector2i(int(r[0]), int(r[1])))


func _capturar_despues(segundos: float, ruta: String) -> void:
	await get_tree().create_timer(segundos).timeout
	await RenderingServer.frame_post_draw
	var imagen := get_viewport().get_texture().get_image()
	var error := imagen.save_png(ruta)
	print("captura: %s (%s)" % [ruta, error_string(error)])
	get_tree().quit()


## Comprobación de punta a punta con ventana real: los clics pasan por el
## mismo camino que los de una persona (Input y el sistema de interfaz), así
## que detecta cualquier control que tape la mano o los botones. En las pruebas
## headless no se puede hacer: la ventana mide 64x64 y el panel de GUT queda
## encima de todo.
func _probar_clics() -> void:
	var fallos: Array[String] = []
	await _hasta(func() -> bool: return controlador.esperando_humano() and _primera_jugable() != null)
	var carta := _primera_jugable()
	var antes := controlador.mano.cartas_de(ASIENTO_PERSONA).size()
	await _clic_real(carta.get_global_rect().get_center())
	if controlador.mano.cartas_de(ASIENTO_PERSONA).size() != antes - 1:
		fallos.append("el clic en la carta no la jugó")
	await _hasta(func() -> bool: return controlador.esperando_humano() and _acciones.get_child_count() > 1)
	var boton: Button = _acciones.get_child(1)  # el 0 es «Hacer una seña…»
	var acciones := controlador.mano.acciones.size()
	await _clic_real(boton.get_global_rect().get_center())
	if controlador.mano.acciones.size() != acciones + 1:
		fallos.append("el clic en el botón «%s» no se aplicó" % boton.text)
	print("PRUEBA DE CLICS: %s" % ("bien" if fallos.is_empty() else "; ".join(fallos)))
	get_tree().quit(0 if fallos.is_empty() else 1)


func _primera_jugable() -> CartaVista:
	for hijo: CartaVista in _mano_propia.get_children():
		if hijo.seleccionable:
			return hijo
	return null


func _hasta(condicion: Callable) -> void:
	var limite := Time.get_ticks_msec() + 30000
	while not condicion.call() and Time.get_ticks_msec() < limite:
		if _aviso.visible:
			_al_cerrar_aviso()
		await get_tree().process_frame


## Clic con coordenadas de ventana (el lienzo puede estar escalado).
func _clic_real(posicion_lienzo: Vector2) -> void:
	var posicion := get_viewport().get_final_transform() * posicion_lienzo
	var mov := InputEventMouseMotion.new()
	mov.position = posicion
	Input.parse_input_event(mov)
	await get_tree().process_frame
	for presionado: bool in [true, false]:
		var ev := InputEventMouseButton.new()
		ev.button_index = MOUSE_BUTTON_LEFT
		ev.pressed = presionado
		ev.position = posicion
		Input.parse_input_event(ev)
		await get_tree().process_frame
	await get_tree().process_frame
