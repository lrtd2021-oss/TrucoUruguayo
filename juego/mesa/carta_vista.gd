class_name CartaVista
extends Control
## Carta provisional del prototipo (Fase 3): un rectángulo con número, palo
## escrito e insignia de pieza. La baraja definitiva llega en la Fase 5.
## La información no depende solo del color: el palo va escrito y la pieza
## lleva su orden.

signal elegida(carta: int)

const TAMANO := Vector2(120, 180)
const NOMBRE_PALO: Array[String] = ["Oros", "Copas", "Espadas", "Bastos"]
const COLOR_PALO: Array[Color] = [Color("c8963e"), Color("a8432f"), Color("2e4a62"), Color("5f6b3a")]
const COLOR_FONDO := Color("ede6d6")
const COLOR_TINTA := Color("1e1e1c")

var carta := -1
var seleccionable := false:
	set(valor):
		seleccionable = valor
		mouse_filter = Control.MOUSE_FILTER_STOP if valor else Control.MOUSE_FILTER_IGNORE
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if valor else Control.CURSOR_ARROW
		modulate = Color.WHITE

var _fondo := Panel.new()
var _numero := Label.new()
var _numero_abajo := Label.new()
var _palo := Label.new()
var _insignia := Label.new()


func _init() -> void:
	custom_minimum_size = TAMANO
	size = TAMANO
	pivot_offset = TAMANO / 2
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	for hijo: Control in [_fondo, _numero, _numero_abajo, _palo, _insignia]:
		hijo.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(hijo)
	_fondo.size = TAMANO
	_numero.position = Vector2(10, 4)
	_numero.add_theme_font_size_override("font_size", 40)
	_numero_abajo.position = Vector2(TAMANO.x - 60, TAMANO.y - 58)
	_numero_abajo.size = Vector2(50, 50)
	_numero_abajo.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_numero_abajo.add_theme_font_size_override("font_size", 40)
	_palo.position = Vector2(0, 56)
	_palo.size = Vector2(TAMANO.x, 40)
	_palo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_palo.add_theme_font_size_override("font_size", 22)
	_insignia.position = Vector2(0, 94)
	_insignia.size = Vector2(TAMANO.x, 26)
	_insignia.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_insignia.add_theme_font_size_override("font_size", 17)
	mouse_entered.connect(func() -> void:
		if seleccionable:
			modulate = Color(1.12, 1.12, 1.12))
	mouse_exited.connect(func() -> void: modulate = Color.WHITE)


## Muestra la carta. Con muestra, marca las piezas (solo para cartas propias o
## ya jugadas: nunca revela nada que el jugador no deba ver).
func mostrar(c: int, muestra: Muestra = null) -> void:
	carta = c
	var p := Carta.palo(c)
	var estilo := _estilo(COLOR_FONDO, COLOR_PALO[p], 5)
	_fondo.add_theme_stylebox_override("panel", estilo)
	var texto := str(Carta.numero(c))
	for etiqueta: Label in [_numero, _numero_abajo, _palo]:
		etiqueta.add_theme_color_override("font_color", COLOR_PALO[p].darkened(0.25))
		etiqueta.visible = true
	_numero.text = texto
	_numero_abajo.text = texto
	_palo.text = NOMBRE_PALO[p]
	_insignia.visible = false
	if muestra and muestra.orden_pieza(c) > 0:
		var k := muestra.orden_pieza(c)
		_insignia.text = "★ pieza %d.ª%s" % [k, " (alc.)" if Carta.numero(c) == 12 else ""]
		_insignia.add_theme_color_override("font_color", COLOR_TINTA)
		_insignia.visible = true
		estilo.border_color = COLOR_TINTA
		estilo.set_border_width_all(7)


## Dorso uniforme: igual para las 40 cartas (sin marcas que revelen nada).
func dorso() -> void:
	carta = -1
	_fondo.add_theme_stylebox_override("panel", _estilo(Color("7a2a20"), COLOR_FONDO, 5))
	for etiqueta: Label in [_numero, _numero_abajo, _palo, _insignia]:
		etiqueta.visible = false


func _gui_input(event: InputEvent) -> void:
	var clic := event as InputEventMouseButton
	if seleccionable and clic and clic.pressed and clic.button_index == MOUSE_BUTTON_LEFT:
		elegida.emit(carta)
		accept_event()


static func _estilo(fondo: Color, borde: Color, ancho: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = fondo
	s.border_color = borde
	s.set_border_width_all(ancho)
	s.set_corner_radius_all(10)
	return s
