# MÓDULO 8 · Sesión 2 — CAMPO DE FLUJO.  🎓 ejercicio
#
# El campo de COSTO ya está armado (el BFS desde la meta). Falta el campo de
# FLUJO: que cada celda guarde el vector hacia el vecino que la acerca a la meta.
#
# 🎓 TU TURNO: completá _construir_flujo(). Sin eso, flujo queda en cero y los
#    agentes no se mueven. Cuando esté, vas a ver las flechas y los agentes fluir.
#    (Solución en _solutions/, solo del docente.)

extends Node2D

const CELL := 20
const COLS := 32
const ROWS := 18
const INF := 1.0e9

@export var seguir_mouse: bool = false
@export var objetivo_fijo := Vector2i(29, 9)
@export_enum("costo", "flujo", "nada") var dibujar: String = "flujo"

var costo: Array[float] = []
var flujo: Array[Vector2] = []
var paredes := {}
var meta := Vector2i.ZERO


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


func _construir_flujo() -> void:
	flujo = []
	flujo.resize(COLS * ROWS)
	flujo.fill(Vector2.ZERO)
	
	for y in ROWS:
		for x in COLS:
			var c = Vector2i(x, y)
			# verificar si estamos en una pared:
			if paredes.has(c) or costo[_i(c)] == INF:
				continue
			
			var mejor = c
			var mejor_costo = costo[_i(c)]
			
			for v in _vecinos8(c):
				if paredes.has(v) or costo[_i(v)] == INF:
					continue
				
				if costo[_i(v)] < mejor_costo:
					mejor_costo = costo[_i(v)]
					mejor = v
			
			# gradiente
			if mejor != c:
				flujo[_i(c)] = Vector2(mejor - c).normalized()



func flujo_en(pos: Vector2) -> Vector2:
	var c := _celda(pos)
	if not _en_grilla(c):
		return Vector2.ZERO
	return flujo[_i(c)]


func es_pared(pos: Vector2) -> bool:
	return paredes.has(_celda(pos))


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


func _celdas_pared() -> Dictionary:
	var s := {}
	for r in range(3, 15):
		s[Vector2i(16, r)] = true
	for c in range(6, 11):
		s[Vector2i(c, 9)] = true
	return s


func _draw() -> void:
	for c in paredes:
		draw_rect(Rect2(c.x * CELL, c.y * CELL, CELL, CELL), Color(0.98, 0.89, 0.69, 0.5))
	if dibujar == "flujo":
		for y in ROWS:
			for x in COLS:
				var c := Vector2i(x, y)
				var f := flujo[_i(c)]
				if f == Vector2.ZERO: continue
				var ce := _centro(c)
				draw_line(ce, ce + f * (CELL * 0.4), Color(0.54, 0.71, 0.98, 0.9), 1.5)
	draw_circle(_centro(meta), 5.0, Color(0.65, 0.89, 0.63))
