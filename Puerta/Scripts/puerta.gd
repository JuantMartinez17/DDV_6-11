extends Sprite2D

@export var es_entrada: bool = true
var puertas_en_grupo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var my_group = get_groups()
	puertas_en_grupo = get_tree().get_nodes_in_group(my_group[0])

func _on_area_2d_body_entered(body: Node2D) -> void:
	for puerta in puertas_en_grupo:
		if puerta != self and es_entrada:
			body.position = puerta.position
