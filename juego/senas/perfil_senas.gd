class_name PerfilSenas
extends RefCounted
## Un perfil de señas: qué gesto corresponde a qué cartas. Se carga de un JSON
## en datos/senas/ (reglamento, punto 11). Un perfil es una tabla, no código:
## agregar otra variante regional es agregar otro archivo.
##
## Tipos de regla en "cartas":
##   {"pieza": k}        la pieza de orden k (el alcahuete activo incluido)
##   {"lista": [...]}    cualquiera de esas cartas (notación "1E")
##   {"numero": n}       cualquier carta de ese número que no sea pieza
##   {"nada": true}      ninguna de las cartas que tienen seña
##   {"flor": true}      la mano tiene flor (no es un conjunto de cartas)

const RUTA_CLASICO := "res://datos/senas/clasico.json"

var id := ""
var nombre := ""
var senas: Array[Dictionary] = []


static func cargar(ruta: String = RUTA_CLASICO) -> PerfilSenas:
	var datos: Variant = JSON.parse_string(FileAccess.get_file_as_string(ruta))
	assert(datos is Dictionary, "perfil de señas ilegible: " + ruta)
	var p := PerfilSenas.new()
	p.id = datos.id
	p.nombre = datos.nombre
	p.senas.assign(datos.senas)
	return p


func sena(sena_id: String) -> Dictionary:
	for s: Dictionary in senas:
		if s.id == sena_id:
			return s
	return {}


## Cartas que significa una seña con esta muestra. Vacío para «nada» y «flor»,
## que no son conjuntos de cartas (ver es_nada y es_flor).
func cartas_de(sena_id: String, m: Muestra) -> Array[int]:
	var r: Array[int] = []
	var regla: Dictionary = sena(sena_id).get("cartas", {})
	for c: int in Carta.mazo():
		if c == m.carta:
			continue
		if regla.has("pieza") and m.orden_pieza(c) == int(regla.pieza):
			r.append(c)
		elif regla.has("lista") and Carta.texto(c) in regla.lista and m.orden_pieza(c) == 0:
			r.append(c)
		elif regla.has("numero") and Carta.numero(c) == int(regla.numero) and m.orden_pieza(c) == 0:
			r.append(c)
	return r


func es_nada(sena_id: String) -> bool:
	return sena(sena_id).get("cartas", {}).has("nada")


func es_flor(sena_id: String) -> bool:
	return sena(sena_id).get("cartas", {}).has("flor")


## Todas las cartas que tienen alguna seña con esta muestra.
func cartas_con_sena(m: Muestra) -> Array[int]:
	var r: Array[int] = []
	for s: Dictionary in senas:
		r.append_array(cartas_de(s.id, m))
	return r


## Seña que corresponde a una carta, o "" si la carta no tiene seña.
func sena_de_carta(c: int, m: Muestra) -> String:
	for s: Dictionary in senas:
		if cartas_de(s.id, m).has(c):
			return s.id
	return ""


## Problemas del perfil con una muestra: una carta con dos señas a la vez.
func conflictos(m: Muestra) -> Array[String]:
	var vistas := {}
	var r: Array[String] = []
	for s: Dictionary in senas:
		for c: int in cartas_de(s.id, m):
			if vistas.has(c):
				r.append("%s tiene dos señas: %s y %s" % [Carta.texto(c), vistas[c], s.id])
			vistas[c] = s.id
	return r
