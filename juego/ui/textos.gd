class_name Textos
extends RefCounted
## Cómo se nombran cartas y acciones ante la persona. Un solo lugar para que
## la mesa, el asistente y el tutorial digan lo mismo.

const PALOS: Array[String] = ["oros", "copas", "espadas", "bastos"]


## «3 de copas», «caballo de oros».
static func carta(c: int) -> String:
	var n := Carta.numero(c)
	var nombre: String = {10: "sota", 11: "caballo", 12: "rey"}.get(n, str(n))
	return "%s de %s" % [nombre, PALOS[Carta.palo(c)]]


## Primera letra en mayúscula y el resto igual («Real envido», no «Real Envido»).
static func mayuscula(texto: String) -> String:
	return texto.left(1).to_upper() + texto.substr(1)


## Texto del botón de una acción, según el canto que esté pendiente.
static func accion(a: Accion, v: Vista) -> String:
	var flor := v.canto_pendiente == Mano.TipoCanto.FLOR
	match a.tipo:
		Accion.Tipo.JUGAR_CARTA:
			return "Jugar el " + carta(a.carta)
		Accion.Tipo.TRUCO:
			var nivel := v.nivel_canto + 1 if v.canto_pendiente == Mano.TipoCanto.TRUCO else v.truco_aceptado + 1
			return mayuscula(Mano.NOMBRE_TRUCO[nivel])
		Accion.Tipo.QUIERO:
			return "Con flor quiero" if flor else "Quiero"
		Accion.Tipo.NO_QUIERO:
			return "Con flor me achico" if flor else "No quiero"
		Accion.Tipo.CANTAR_FLOR:
			return "Flor"
		Accion.Tipo.CONTRAFLOR_AL_RESTO:
			return "Contraflor al resto"
		Accion.Tipo.CON_FLOR_ME_ACHICO:
			return "Con flor me achico"
		Accion.Tipo.ENVIDO:
			return "Envido"
		Accion.Tipo.REAL_ENVIDO:
			return "Real envido"
		Accion.Tipo.FALTA_ENVIDO:
			return "Falta envido"
		Accion.Tipo.IR_AL_MAZO:
			return "Irse al mazo"
	return str(a)
