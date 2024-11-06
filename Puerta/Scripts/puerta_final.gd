extends Sprite2D

signal cambio_escena

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	emit_signal("cambio_escena")
