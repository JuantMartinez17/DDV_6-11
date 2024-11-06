extends ColorRect

# Función para desvanecer la pantalla al mostrar la nueva escena
func fade_in():
	modulate = Color(0, 0, 0, 1)  # Comenzar con negro completo
	$Tween.tween_property(self, "modulate:a", 0, 1)  # Desvanecer al mostrar la escena en 1 segundo

func _on_scene_loaded():
	fade_in()  # Una vez la escena se carga, se inicia el desvanecimiento de regreso
