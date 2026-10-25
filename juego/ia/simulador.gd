class_name Simulador
extends RefCounted
## Juega el resto de las bazas de una mano con una política simple para todos,
## sobre una hipótesis de cartas. Las reglas (quién gana la baza, quién gana
## la mano) son las de Mano: no hay una copia propia.


## manos: lo que le queda a cada jugador. forzada: carta que juega primero el
## jugador de turno (-1 para que decida la política). Devuelve el equipo
## ganador de la mano.
static func jugar(manos: Array[Array], mesa_inicial: Array[int], abre: int, turno: int,
		resultados_iniciales: Array[int], jugador_mano: int, m: Muestra, forzada := -1) -> int:
	var restantes: Array[Array] = []
	for mano: Array in manos:
		restantes.append(mano.duplicate())
	var mesa := mesa_inicial.duplicate()
	var resultados := resultados_iniciales.duplicate()
	var j := turno
	var guarda := 0
	while guarda < 16:
		guarda += 1
		if not mesa.has(-1):
			var g := Mano.ganador_baza(mesa, abre, m)
			resultados.append(g.resultado)
			var ganador := Mano.ganador_por_bazas(resultados, jugador_mano)
			if ganador >= 0:
				return ganador
			if g.jugador >= 0:
				abre = g.jugador
			mesa.fill(-1)
			j = abre
			continue
		if restantes[j].is_empty():
			break  # hipótesis incompleta: no debería pasar
		var c := forzada if forzada >= 0 else politica(j, restantes[j], mesa, abre, resultados, m)
		forzada = -1
		restantes[j].erase(c)
		mesa[j] = c
		j = (j + 1) % Mano.JUGADORES
	return Mano.ganador_por_bazas(resultados, jugador_mano)


## Si abre, tira su carta más alta. Si su compañero va ganando la baza, la más
## baja. Si no, la más baja que mata; si no puede matar, la más baja.
static func politica(j: int, cartas: Array, mesa: Array[int], abre: int, _resultados: Array[int], m: Muestra) -> int:
	var orden := cartas.duplicate()
	orden.sort_custom(func(a: int, b: int) -> bool: return m.poder(a) < m.poder(b))
	if mesa[abre] < 0:
		return orden.back()
	var mejor := -1
	var dueno := -1
	for k: int in Mano.JUGADORES:
		var s := (abre + k) % Mano.JUGADORES
		if mesa[s] >= 0 and m.poder(mesa[s]) > mejor:
			mejor = m.poder(mesa[s])
			dueno = s
	if Mano.equipo(dueno) == Mano.equipo(j):
		return orden[0]
	for c: int in orden:
		if m.poder(c) > mejor:
			return c
	return orden[0]
