extends Sprite2D

# === SPRITE QUE REBOTA (✅ demo) ===========================================
# El "juego" de mentira que vive debajo de los shaders de pantalla: un
# sprite que rebota contra los bordes. Igual que el cuadrado del módulo 9.
# ===========================================================================

@export var velocidad := Vector2(240, 170)

func _process(delta: float) -> void:
	position += velocidad * delta
	var limites := get_viewport_rect().size
	if position.x < 50.0 or position.x > limites.x - 50.0:
		velocidad.x = -velocidad.x
		position.x = clampf(position.x, 50.0, limites.x - 50.0)
	if position.y < 50.0 or position.y > limites.y - 50.0:
		velocidad.y = -velocidad.y
		position.y = clampf(position.y, 50.0, limites.y - 50.0)
