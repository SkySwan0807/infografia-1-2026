extends Label
var contador = 0

func _on_button_pressed() -> void:
	print("hola bola!")
	contador += 1
	text = str(contador)
