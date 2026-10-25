class_name Asistente
extends RefCounted
## Sugerencias para la persona (modo de aprendizaje y partida guiada).
## Usa la misma IA con un perfil neutral, sin faroles ni errores, y solo la
## Vista de la persona: no puede revelar cartas ocultas (prueba T-10).
## Las probabilidades que menciona son estimaciones por muestreo.


static func sugerir(v: Vista, senas: PerfilSenas, semilla := 0) -> Dictionary:
	var rng := RandomNumberGenerator.new()
	rng.seed = semilla
	var perfil := PerfilIA.crear("neutral", PerfilIA.Dificultad.DIFICIL)
	var d := IaMuestreo.decidir_con_detalle(v, perfil, senas, rng)
	var a: Accion = d.accion
	var texto := "Te sugiero: %s." % Textos.accion(a, v).to_lower()
	var estimacion := ""
	if d.p_mano >= 0.0 and (a.tipo == Accion.Tipo.JUGAR_CARTA or a.tipo == Accion.Tipo.TRUCO \
			or v.canto_pendiente == Mano.TipoCanto.TRUCO):
		estimacion = " Con lo que se sabe, ganarían la mano unas %d de cada 10 veces." % roundi(d.p_mano * 10)
	elif d.p_envido >= 0.0:
		estimacion = " Tu tanto ganaría el envido unas %d de cada 10 veces." % roundi(d.p_envido * 10)
	elif d.p_flor >= 0.0:
		estimacion = " Tu flor ganaría unas %d de cada 10 veces." % roundi(d.p_flor * 10)
	return {"accion": a, "texto": texto + estimacion, "detalle": d}
