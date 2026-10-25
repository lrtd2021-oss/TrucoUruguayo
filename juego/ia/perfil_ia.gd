class_name PerfilIA
extends RefCounted
## Personalidad y dificultad de un jugador de la computadora.
##
## La personalidad cambia decisiones dentro de lo legal (cuánto arriesga, cuánto
## farolea, cuánto disimula sus señas). La dificultad cambia cuánto piensa
## (cantidad de muestras), si deduce cosas de lo que vio y cuánto se equivoca.
## Ninguna cambia la información disponible: todos juegan con su Vista.

enum Dificultad { FACIL, NORMAL, DIFICIL }

## Valores de 0 a 1. Ver docs/PERSONAJES.md.
const PERSONALIDADES := {
	"tito": {"agresividad": 0.75, "farol": 0.25, "prudencia": 0.3, "atencion": 0.5, "disimulo": 0.2},
	"marta": {"agresividad": 0.35, "farol": 0.04, "prudencia": 0.7, "atencion": 0.75, "disimulo": 0.8},
	"cacho": {"agresividad": 0.85, "farol": 0.3, "prudencia": 0.25, "atencion": 0.55, "disimulo": 0.4},
	"rosario": {"agresividad": 0.45, "farol": 0.1, "prudencia": 0.6, "atencion": 0.65, "disimulo": 0.9},
	"washa": {"agresividad": 0.65, "farol": 0.2, "prudencia": 0.35, "atencion": 0.4, "disimulo": 0.1},
	"neutral": {"agresividad": 0.5, "farol": 0.0, "prudencia": 0.5, "atencion": 0.5, "disimulo": 0.5},
}

var nombre := "neutral"
var agresividad := 0.5
var farol := 0.0
var prudencia := 0.5
var atencion := 0.5
var disimulo := 0.5
var muestras := 16
var usar_inferencias := true
var errores := 0.0


static func crear(personaje: String, dificultad: Dificultad = Dificultad.NORMAL) -> PerfilIA:
	var p := PerfilIA.new()
	var datos: Dictionary = PERSONALIDADES[personaje]
	p.nombre = personaje
	p.agresividad = datos.agresividad
	p.farol = datos.farol
	p.prudencia = datos.prudencia
	p.atencion = datos.atencion
	p.disimulo = datos.disimulo
	match dificultad:
		Dificultad.FACIL:
			p.muestras = 6
			p.usar_inferencias = false
			p.errores = 0.15
			p.atencion *= 0.6
		Dificultad.NORMAL:
			p.muestras = 16
			p.errores = 0.04
		Dificultad.DIFICIL:
			p.muestras = 40
			p.atencion = minf(1.0, p.atencion * 1.25)
	return p


## Perfil de la persona para la observación de señas (atención y disimulo
## medios). Lo usa el controlador; la persona decide por sí misma.
static func persona() -> PerfilIA:
	return crear("neutral")
