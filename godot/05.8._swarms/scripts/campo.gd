# MÓDULO 8 · Sesión 2 — el CAMPO DE FLUJO (demo completo).
#
# Un flow field resuelve el pathfinding UNA vez para TODO el mapa, no por agente.
# Se arma en dos pasos sobre una grilla (la misma idea de la grilla de la 5.6):
#
#   1) CAMPO DE COSTO  — desde la meta, un BFS reparte "qué tan lejos está cada
#      celda de la meta" (0 en la meta, +1 por paso, las paredes no se cruzan).
#   2) CAMPO DE FLUJO  — cada celda guarda UN vector: hacia el vecino con menor
#      costo (o sea, "el paso que te acerca a la meta").
#
# Después, miles de agentes solo leen el vector de su celda y caminan. Barato:
# el trabajo pesado (el BFS) se hizo una sola vez.

extends Node2D

const CELL := 20
const COLS := 32   # 640 / 20
const ROWS := 18   # 360 / 20
const INF := 1.0e9

@export var seguir_mouse: bool = false        # la meta es el mouse (escena 07)
@export var objetivo_fijo := Vector2i(29, 9)   # meta cuando no seguimos el mouse
@export_enum("costo", "flujo", "nada") var dibujar: String = "costo"

var costo: Array[float] = []
var flujo: Array[Vector2] = []
var paredes := {}
var meta := Vector2i.ZERO
var _ultima_meta := Vector2i(-999, -999)


func _ready() -> void:
	paredes = _celdas_pared()
	meta = objetivo_fijo
	_reconstruir()


func _process(_delta: float) -> void:
	if seguir_mouse:
		var c := _celda(get_global_mouse_position())
		if _en_grilla(c) and not paredes.has(c) and c != meta:
			meta = c
			_reconstruir()


func _reconstruir() -> void:
	_construir_costo()
	_construir_flujo()
	queue_redraw()


# --- paso 1: BFS desde la meta (campo de costo) ---
func _construir_costo() -> void:
	costo = []
	costo.resize(COLS * ROWS)
	costo.fill(INF)
	if paredes.has(meta):
		return
	var cola: Array[Vector2i] = [meta]
	costo[_i(meta)] = 0.0
	while not cola.is_empty():
		var c: Vector2i = cola.pop_front()
		for v in _vecinos4(c):
			if not paredes.has(v) and costo[_i(v)] == INF:
				costo[_i(v)] = costo[_i(c)] + 1.0
				cola.append(v)


# --- paso 2: cada celda apunta al vecino más barato (campo de flujo) ---
func _construir_flujo() -> void:
	flujo = []
	flujo.resize(COLS * ROWS)
	flujo.fill(Vector2.ZERO)
	for y in ROWS:
		for x in COLS:
			var c := Vector2i(x, y)
			if paredes.has(c) or costo[_i(c)] == INF:
				continue
			var mejor := c
			var mejor_costo := costo[_i(c)]
			for v in _vecinos8(c):
				if paredes.has(v) or costo[_i(v)] == INF:
					continue
				if costo[_i(v)] < mejor_costo:
					mejor_costo = costo[_i(v)]
					mejor = v
			if mejor != c:
				flujo[_i(c)] = Vector2(mejor - c).normalized()


# lo que consulta cada agente: el vector de flujo en su posición
func flujo_en(pos: Vector2) -> Vector2:
	var c := _celda(pos)
	if not _en_grilla(c):
		return Vector2.ZERO
	return flujo[_i(c)]


func es_pared(pos: Vector2) -> bool:
	return paredes.has(_celda(pos))


# ---------- helpers de grilla ----------
func _i(c: Vector2i) -> int: return c.y * COLS + c.x
func _celda(pos: Vector2) -> Vector2i: return Vector2i(int(pos.x / CELL), int(pos.y / CELL))
func _centro(c: Vector2i) -> Vector2: return Vector2(c.x * CELL + CELL / 2.0, c.y * CELL + CELL / 2.0)
func _en_grilla(c: Vector2i) -> bool: return c.x >= 0 and c.x < COLS and c.y >= 0 and c.y < ROWS

func _vecinos4(c: Vector2i) -> Array:
	var r := []
	for d in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
		if _en_grilla(c + d): r.append(c + d)
	return r

func _vecinos8(c: Vector2i) -> Array:
	var r := []
	for dy in [-1, 0, 1]:
		for dx in [-1, 0, 1]:
			if dx == 0 and dy == 0: continue
			var v := c + Vector2i(dx, dy)
			if _en_grilla(v): r.append(v)
	return r


# pared: un muro vertical con dos pasos (arriba y abajo) + un tope horizontal
func _celdas_pared() -> Dictionary:
	var s := {}
	for r in range(3, 15):
		s[Vector2i(16, r)] = true
	for c in range(6, 11):
		s[Vector2i(c, 9)] = true
	return s


# ---------- dibujo (para VER el campo) ----------
func _draw() -> void:
	# paredes
	for c in paredes:
		draw_rect(Rect2(c.x * CELL, c.y * CELL, CELL, CELL), Color(0.98, 0.89, 0.69, 0.5))

	if dibujar == "costo":
		_dibujar_costo()
	elif dibujar == "flujo":
		_dibujar_flujo()

	# meta
	draw_circle(_centro(meta), 5.0, Color(0.65, 0.89, 0.63))


func _dibujar_costo() -> void:
	# normalizar el costo para colorear (cerca de la meta = claro, lejos = oscuro)
	var maxc := 1.0
	for v in costo:
		if v < INF and v > maxc: maxc = v
	for y in ROWS:
		for x in COLS:
			var c := Vector2i(x, y)
			var k := costo[_i(c)]
			if k >= INF or paredes.has(c): continue
			var t := k / maxc
			draw_rect(Rect2(x * CELL, y * CELL, CELL, CELL), Color(0.3, 0.7, 1.0).lerp(Color(0.1, 0.1, 0.2), t))


func _dibujar_flujo() -> void:
	for y in ROWS:
		for x in COLS:
			var c := Vector2i(x, y)
			var f := flujo[_i(c)]
			if f == Vector2.ZERO: continue
			var ce := _centro(c)
			draw_line(ce, ce + f * (CELL * 0.4), Color(0.54, 0.71, 0.98, 0.9), 1.5)
			draw_circle(ce + f * (CELL * 0.4), 1.5, Color(0.54, 0.71, 0.98))
