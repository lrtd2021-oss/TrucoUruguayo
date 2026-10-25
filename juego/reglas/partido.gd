class_name Partido
extends RefCounted
## Un partido completo: reparte con una semilla propia, rota el reparto y
## lleva el tanteador hasta que una pareja llega al objetivo.

var reglamento: Reglamento
var rng := RandomNumberGenerator.new()
var puntos: Array[int] = [0, 0]
var repartidor: int
var decisor: Array[int] = [-1, -1]
var mano_actual: Mano
var manos_jugadas := 0
var ganador := -1


func _init(reg: Reglamento, semilla: int, repartidor_inicial := 3) -> void:
	reglamento = reg
	rng.seed = semilla
	repartidor = repartidor_inicial


## Mezcla y reparte de a una carta en sentido antihorario, empezando por la
## mano; la carta siguiente es la muestra.
func nueva_mano() -> Mano:
	assert(ganador < 0, "el partido ya terminó")
	var mazo := Carta.mazo()
	Carta.mezclar(mazo, rng)
	var manos: Array = [[], [], [], []]
	var primero := (repartidor + 1) % Mano.JUGADORES
	for vuelta: int in 3:
		for k: int in Mano.JUGADORES:
			var j := (primero + k) % Mano.JUGADORES
			manos[j].append(mazo[vuelta * Mano.JUGADORES + k])
	mano_actual = Mano.new(reglamento, mazo[12], manos, repartidor, puntos)
	mano_actual.decisor = decisor.duplicate()
	return mano_actual


## Toma el resultado de la mano terminada y pasa el reparto a la derecha.
func cerrar_mano() -> void:
	assert(mano_actual.fase == Mano.Fase.TERMINADA, "la mano no terminó")
	puntos = mano_actual.puntos.duplicate()
	ganador = mano_actual.ganador_partido
	manos_jugadas += 1
	repartidor = (repartidor + 1) % Mano.JUGADORES
