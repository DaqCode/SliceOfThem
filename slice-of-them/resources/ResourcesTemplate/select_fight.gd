extends Button

@export var hover_scale: float = 1.05  # Scale when hovered
@export var normal_scale: float = 1.0  # Default scale
@export var tween_duration: float = 0.1  # Smooth transition time

@export var battle_id: int = 0  # Unique ID for each battle
signal battle_selected(battle_id: int)  # Signal to send battle info

var tween: Tween = null

func _on_mouse_entered() -> void:
	animate_scale(hover_scale)

func _on_mouse_exited() -> void:
	animate_scale(normal_scale)

func animate_scale(target_scale: float) -> void:
	if tween:
		tween.kill()  # Kill any existing tween before starting a new one
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(target_scale, target_scale), tween_duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _on_pressed() -> void:
	print("Battle Selected:", battle_id)
	battle_selected.emit(battle_id)  # Send the battle ID