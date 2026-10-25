extends RefCounted
## Atajos para escribir las pruebas. No es una prueba (no empieza con test_).


static func a(tipo: Accion.Tipo, j: int, carta := "") -> Accion:
	return Accion.new(tipo, j, Carta.desde_texto(carta) if carta != "" else -1)


static func carta(j: int, t: String) -> Accion:
	return a(Accion.Tipo.JUGAR_CARTA, j, t)


## Aplica una lista de acciones y falla con el detalle si alguna se rechaza.
static func aplicar(m: Mano, acciones: Array[Accion]) -> String:
	for acc: Accion in acciones:
		var r := m.aplicar(acc)
		if not r.ok:
			return "%s: %s" % [acc, r.error]
	return ""


static func tipos(acciones: Array[Accion]) -> Array[int]:
	var r: Array[int] = []
	for acc: Accion in acciones:
		r.append(acc.tipo)
	return r


## Juega la primera carta posible (o la acción obligatoria) hasta que la mano
## termina. Sirve para resolver las bazas cuando la prueba no depende de ellas.
static func jugar_hasta_terminar(m: Mano) -> void:
	var guarda := 0
	while m.fase != Mano.Fase.TERMINADA and guarda < 100:
		guarda += 1
		var validas := m.acciones_validas(m.actor())
		var elegida: Accion = validas[0]
		for acc: Accion in validas:
			if acc.tipo == Accion.Tipo.JUGAR_CARTA:
				elegida = acc
				break
		m.aplicar(elegida)
