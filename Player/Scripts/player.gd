extends CharacterBody2D

# Constantes para la velocidad y la gravedad
const SPEED = 600           # Velocidad horizontal del personaje
const JUMP_FORCE = -1000    # Fuerza aplicada al saltar (negativo para moverse hacia arriba)
const GRAVITY = 900         # Gravedad aplicada al personaje

# Inventario del jugador
var inventory = []

# Variables relacionadas con la animación
@onready var animation_tree = $AnimationTree                          		# Referencia al nodo AnimationTree
@onready var animation_state = animation_tree.get("parameters/playback")  	# Controlador de animaciones

# Enumarator con las posibles orientacions del personaje.
enum CharacterOrientation {
	RIGHT = 1,   # Orientación hacia la derecha
	LEFT = -1    # Orientación hacia la izquierda
}

var facing = CharacterOrientation.RIGHT       # Dirección actual en la que mira el personaje (derecha por defaul al comenzar el juego).
var old_facing = CharacterOrientation.RIGHT   # Dirección anterior para detectar los cambios en esta.

# Enumarator para los estados del personaje (idle, salto, correr, etc).
enum CharacterState {
	IDLE,
	RUN_START,
	RUNNING,
	RUN_END,
	JUMP_START,
	JUMP_UP,
	JUMP_END,
}

var character_state = CharacterState.IDLE     # Estado actual del personaje (IDLE por defecto al inicial el juego).

# Variables para el input.
var input_direction = 0                       # Direccion horizontal (-1, 0, 1).
var jump_pressed = false                      # Indica si se ha presionado el boton de salto.
var was_running = false                       # Indica si el personaje estaba corriendo en el frame anterior.

func _physics_process(delta):
	# Se ejecuta en cada frame de fisica (frecuencia fija, por defecto 15 veces por segundo)
	# delta es el tiempo transcurrido desde el último frame

	# Lee la entrada del usuario.
	get_input()

	# Actualiza la orientacion del avatar.
	update_direction(input_direction)

	# Aplica las fuerzas y setea el estado del personaje para luego poder seleccionar la animacion correcta.
	movement(delta)

	# Aplica los cambios en las velocidades X e Y al charater.
	move_and_slide()					# Permite que el CharacterBody sea procesado por el motor de fisicas.

	# Actualiza las animaciones segun el estado del personaje.
	update_animation()

func get_input():
	# Lee la entrada del usuario y actualiza las variables correspondientes.

	# Direccion horizontal de entrada (-1 para izquierda, 1 para derecha).
	input_direction = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")

	# Verifica si se presiono el boton de salto.
	jump_pressed = Input.is_action_just_pressed("ui_accept")

func update_direction(input_direction):
	# Actualiza la orientación del personaje y voltea el sprite si es necesario

	# Determina la nueva orientación a partir del input del jugador.
	if input_direction > 0:
		facing = CharacterOrientation.RIGHT
	elif input_direction < 0:
		facing = CharacterOrientation.LEFT

	# Si la orientacion cambio, invierte el sprite.
	if facing != old_facing and input_direction != 0:
		flip_character()
		old_facing = facing

func flip_character():
	# Invierte el sprite del personaje en el eje X.
	scale.x *= -1

func movement(delta):
	# Calcula la velocidad horizontal.
	velocity.x = input_direction * SPEED

	# Setea el estado del personaje, para que la funcion update_animation() pueda seleccionar la animacion correspondiente.
	if not is_on_floor():
		# Si el personaje esta en el aire, aplicamos gravedad
		velocity.y += GRAVITY * delta

		# Si no estamos ya en el estado JUMP_UP, lo establecemos
		if character_state != CharacterState.JUMP_UP:
			character_state = CharacterState.JUMP_UP
	else:
		# Si el personaje esta en el suelo
		if character_state == CharacterState.JUMP_UP:
			# El personaje acaba de aterrizar
			character_state = CharacterState.JUMP_END
		elif jump_pressed:
			# Si se presiono el botón de salto
			velocity.y = JUMP_FORCE
			character_state = CharacterState.JUMP_START
		else:
			# Manejo de estados de correr y parar
			if input_direction != 0: 		# Si hay movimiento horitontal:
				if not was_running:			# Y no estaba corriendo, pasa al estado run_state.
					character_state = CharacterState.RUN_START
					was_running = true		# Flag para indicar que esta corriendo.

				else:						# Si ya estaba corriendo, mantiene el estado de running.
					character_state = CharacterState.RUNNING
			else:
				# Si no hay movimiento horizontal:
				if was_running:										# Y estaba corriendo, pasa a run_end.
					character_state = CharacterState.RUN_END
					was_running = false								# Indica que ya no esta cooriendo.
				else:
					# Y en caso contrario queda en idle.
					character_state = CharacterState.IDLE

func update_animation():
	# Selecciona la animación a reproducir segun el estado del personaje
	match character_state:
		CharacterState.IDLE:
			animation_state.travel("idle")
		CharacterState.RUN_START:
			# El AnimationTree transiciona automáticamente de 'run_start' a 'running'
			# Actualizamos el estado para reflejar esto
			animation_state.travel("run_start")
			character_state = CharacterState.RUNNING
		CharacterState.RUNNING:
			animation_state.travel("running")
		CharacterState.RUN_END:
			animation_state.travel("run_end")
			# Después de 'run_end', cambiamos el estado a IDLE
			character_state = CharacterState.IDLE
		CharacterState.JUMP_START:
			animation_state.travel("jump_start")
			# El AnimationTree transiciona automáticamente de 'jump_start' a 'jump_up'
			# Actualizamos el estado para reflejar esto
			character_state = CharacterState.JUMP_UP
		CharacterState.JUMP_UP:
			animation_state.travel("jump_up")
		CharacterState.JUMP_END:
			animation_state.travel("jump_end")
			# Después de reproducir 'jump_end', volvemos al estado IDLE o RUNNING según la entrada
			if input_direction != 0:
				character_state = CharacterState.RUNNING
			else:
				character_state = CharacterState.IDLE

func add_to_inventory(item_name):
	# Agrega un item al inventario y muestra el contenido actual
	inventory.append(item_name)
	print("Recogido:", item_name, "- Inventario:", inventory)
