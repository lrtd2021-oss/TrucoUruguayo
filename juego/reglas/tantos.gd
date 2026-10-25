class_name Tantos
extends RefCounted
## Cálculo de envido y flor. Reglamento, puntos 5.2 y 5.3.
##
## Los desgloses explican cada cuenta para el tutorial: {valor, partes, veinte},
## donde partes es una lista de [carta, aporte] y veinte indica si se sumaron
## los 20 por cartas del mismo palo. Siempre vale: valor = suma de aportes
## + 20 si veinte. Una pieza ya incluye los 20 en su valor (30 a 27).


## Envido de una mano de tres cartas. Si la mano tiene flor, el envido no se
## juega (la flor lo anula); el valor devuelto en ese caso no lo define el
## reglamento y solo cuenta la pieza más alta con la mejor carta restante.
static func envido(cartas: Array[int], m: Muestra) -> int:
	return desglose_envido(cartas, m).valor


static func desglose_envido(cartas: Array[int], m: Muestra) -> Dictionary:
	var piezas := _piezas_ordenadas(cartas, m)
	if not piezas.is_empty():
		# La pieza vale como de cualquier palo: se suma la mejor de las otras dos.
		var p := piezas[0]
		var mejor := -1
		for c: int in cartas:
			if c != p and (mejor < 0 or _aporte(c, m) > _aporte(mejor, m)):
				mejor = c
		return _desglose([[p, m.valor_tanto(p)], [mejor, _aporte(mejor, m)]], false)
	var r := _desglose([], false)
	for i: int in cartas.size():
		var v := m.valor_tanto(cartas[i])
		if v > r.valor:
			r = _desglose([[cartas[i], v]], false)
		for j: int in range(i + 1, cartas.size()):
			if Carta.palo(cartas[i]) == Carta.palo(cartas[j]):
				var par := _desglose([[cartas[i], v], [cartas[j], m.valor_tanto(cartas[j])]], true)
				if par.valor > r.valor:
					r = par
	return r


static func tiene_flor(cartas: Array[int], m: Muestra) -> bool:
	var piezas := _piezas_ordenadas(cartas, m)
	if piezas.size() >= 2:
		return true
	var resto := cartas.filter(func(c: int) -> bool: return not (c in piezas))
	var p0 := Carta.palo(resto[0])
	return resto.all(func(c: int) -> bool: return Carta.palo(c) == p0)


static func valor_flor(cartas: Array[int], m: Muestra) -> int:
	return desglose_flor(cartas, m).valor


## La pieza más alta cuenta completa, las demás piezas solo su unidad
## (valor - 20) y el resto su valor normal. Sin piezas, 20 + la suma.
static func desglose_flor(cartas: Array[int], m: Muestra) -> Dictionary:
	assert(tiene_flor(cartas, m), "la mano no tiene flor")
	var piezas := _piezas_ordenadas(cartas, m)
	var partes: Array = []
	if piezas.is_empty():
		for c: int in cartas:
			partes.append([c, m.valor_tanto(c)])
		return _desglose(partes, true)
	partes.append([piezas[0], m.valor_tanto(piezas[0])])
	for c: int in cartas:
		if c != piezas[0]:
			partes.append([c, _aporte(c, m)])
	return _desglose(partes, false)


static func _desglose(partes: Array, veinte: bool) -> Dictionary:
	var valor := 20 if veinte else 0
	for p: Array in partes:
		valor += p[1]
	return {"valor": valor if not partes.is_empty() else -1, "partes": partes, "veinte": veinte}


static func _piezas_ordenadas(cartas: Array[int], m: Muestra) -> Array[int]:
	var r: Array[int] = cartas.filter(func(c: int) -> bool: return m.orden_pieza(c) > 0)
	r.sort_custom(func(a: int, b: int) -> bool: return m.orden_pieza(a) < m.orden_pieza(b))
	return r


## Aporte de una carta que acompaña a la pieza principal: otra pieza aporta
## solo su unidad; las demás, su valor de tanto.
static func _aporte(c: int, m: Muestra) -> int:
	return m.valor_tanto(c) - (20 if m.orden_pieza(c) > 0 else 0)
