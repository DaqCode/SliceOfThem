extends Control

func _ready() -> void:
	GenericMusic.stop()
	$AnimationPlayer.play()

func _on_animation_player_animation_finished(anim_name:String) -> void:
	if anim_name == "o-o":
		GenericMusic.play()
		get_tree().change_scene_to_file("res://scenes/area/maps/map_direction.tscn")