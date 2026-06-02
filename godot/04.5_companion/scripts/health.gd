extends Node
class_name Health

# Componente de vida reutilizable.
# No sabe nada de animaciones ni de input: solo lleva la cuenta y avisa
# con señales. El que decide QUÉ hacer cuando la vida cambia es el dueño
# (el player o el enemigo), conectándose a estas señales.

signal health_changed(old_value: int, new_value: int)
signal health_depleted

@export var max_health: int = 100
var health: int

func _ready() -> void:
	health = max_health

# Recibe el HitBox que nos golpeó y le resta su daño.
func take_damage(hit: HitBox) -> void:
	var old := health
	health = max(0, health - hit.damage)
	health_changed.emit(old, health)
	if health == 0:
		health_depleted.emit()
