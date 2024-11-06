extends CanvasLayer

func _ready():
	visible = false

func _input(event):
	# Si se presiona Escape, mostramos/ocultamos el menú
	if event.is_action_pressed("esc"):
		toggle_pause()

func toggle_pause():
	# Cambia el estado de la pausa.
	if get_tree().paused:
		get_tree().paused = false
		visible = false
	else:
		get_tree().paused = true
		visible = true

func _on_continue_pressed():
	# Reanudar el juego
	toggle_pause()

func _on_restart_pressed():
	# Reiniciar la escena actual
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_pressed():
	# Salir del juego o regresar al menú principal
	get_tree().quit()

func _on_coninue_pressed() -> void:
	toggle_pause()
 
