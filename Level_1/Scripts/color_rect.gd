extends ColorRect

var tween : Tween
var animation_player : AnimationPlayer
var scene

func _ready() -> void:
	scene = load("res://Level_1/Scenes/level_2.tscn").instantiate()
	animation_player = $"../../AnimationPlayer"
	if has_node("../../Puerta_final"):
		$"../../Puerta_final".cambio_escena.connect(fade_out)

func fade_out():
	animation_player.play("FadeOut")

func fade_in():
	animation_player.play("FadeIn")

func Next_level():
	#if (get_tree().current_scene).name == "Level_1":
	get_tree().change_scene_to_file("res://Level_1/Scenes/level_2.tscn")
