extends Node2D

@export var position_base : Vector2

func _ready() -> void:
	if position_base != Vector2(0,0):
		$Area2D.position = position_base
