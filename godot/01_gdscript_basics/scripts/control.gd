extends Control

# obtener una referencia al label Score

@onready var score_label: Label = $Score

var current_score: int = 0

func _ready() -> void:
	update_score_label()
	var coins_instances = get_tree().get_nodes_in_group("coin")
	
	for coin_instance in coins_instances:
		if coin_instance:
			# conectar a la señal
			print("conectando señal...")
			coin_instance.coin_collected.connect(on_coin_collected)
	
func update_score_label():
	score_label.text = "Score: " + str(current_score)

func on_coin_collected(value: int):
	print("coin received for UI")
	current_score += value
	update_score_label()
