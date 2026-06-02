extends ProgressBar

# === BARRA DE VIDA (componente COMPLETO) ==================================
# No sabe de quien es la vida: le pasas el nodo Health por el inspector y se
# conecta solo a su señal health_changed. Mismo patron que Health: el modelo
# avisa con señales, la UI reacciona. Sirve igual para el player y para el pet.
# ==========================================================================

@export var health_node: Node

func _ready() -> void:
	var health := health_node as Health
	if health == null:
		push_warning("HealthBar: falta asignar un nodo Health en el inspector")
		return
	max_value = health.max_health
	value = health.max_health
	health.health_changed.connect(_on_health_changed)


func _on_health_changed(_old_value: int, new_value: int) -> void:
	value = new_value
