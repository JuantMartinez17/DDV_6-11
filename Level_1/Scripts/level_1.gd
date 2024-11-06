extends Node2D

var save_data = {
	"player_name": "Jugador1",
	"score": 10,
	"dinero": 128,
	"inventory": ["Espada", "Amuleto"]
	}

var save_data_array = ["martin", 10, 1, -3 ]

var read_data = {}
var read_data_b = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	save_game (save_data)
	read_data = read_game ()
	print ("LEIDO: ", read_data)
	save_game_binary(save_data_array)
	print ("LEIDO BINARIO: ", read_data_b)
	read_data_b = read_game_binary()
	print ("LEIDO BINARIO: ", read_data_b)

func save_game(json_data: Dictionary) -> void:
	var file := FileAccess.open("user://save_game.json", FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(json_data)
		file.store_string(json_string)
		file.close()
		print("Juego guardado correctamente.")
	else:
		print("Error al abrir el archivo para guardar.")

func read_game() -> Dictionary:
	var file := FileAccess.open("user://save_game.json", FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()

		var json = JSON.new()
		var result = json.parse(json_string)  # El resultado es un código de error, no un objeto.
		
		if result == OK:
			var parsed_data = json.get_data()  # Obtener los datos ya parseados
			print("Juego cargado correctamente.")
			return parsed_data
		else:
			print("Error al parsear el JSON: ", result)
			return {}
	else:
		print("Error al abrir el archivo para leer.")
		return {}

func save_game_binary(data_array: Array) -> void:
	var file := FileAccess.open("user://save_game.bin", FileAccess.WRITE)
	if file:
		file.store_var(data_array)  # Serializa todo el array con store_var
		file.close()
		print("Datos guardados correctamente en binario.")
	else:
		print("Error al abrir el archivo para guardar.")

func read_game_binary() -> Array:
	var file := FileAccess.open("user://save_game.bin", FileAccess.READ)
	if file:
		var data_array = file.get_var()  # Deserializa todo el array con get_var
		file.close()
		print("Datos leídos correctamente en binario.")
		return data_array
	else:
		print("Error al abrir el archivo para leer.")
		return []
