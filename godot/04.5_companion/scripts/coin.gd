extends Area2D

# SIGNALS
signal collected

func _on_body_entered(body: Node2D) -> void:
	# check if player entered
	if body.is_in_group("player"):
		# emit signal
		emit_signal("collected")
		# harakiri
		queue_free()
