extends Area2D
class_name HitBox

# El HitBox es el área que HACE daño (el golpe).
# Vive en la capa "player_hit" o "enemy_hit" (sesión 3).
# Su CollisionShape arranca deshabilitado: solo se activa durante
# la animación de ataque, mediante una pista de la animación.

@export var damage: int = 10
