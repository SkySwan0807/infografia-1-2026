class_name Player2
extends CharacterBody2D

# propiedades

# privadas
var player_name = "Mario trucho"
var time = 0.0
# publicas
@export var speed: int = 300


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("hola!")
	print("speed: ", speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	

func _physics_process(delta: float) -> void:
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = 0
		
	move_and_slide()
