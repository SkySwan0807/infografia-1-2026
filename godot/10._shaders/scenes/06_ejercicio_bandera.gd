extends Control

@export var rect: ColorRect;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_up() -> void:
	print("1")
	rect.material.set("shader_parameter/freq", 2)

func _on_button_2_button_up() -> void:
	print("2")
	rect.material.set("shader_parameter/freq", 4)
	

func _on_button_3_button_up() -> void:
	print("3")
	rect.material.set("shader_parameter/freq", 8)
