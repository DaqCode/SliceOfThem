extends "res://resources/sword/BaseSword.gd"

@onready var animation : AnimationPlayer = $AnimationControl

func _ready() -> void:
	await get_tree().create_timer(randf_range(0.0,0.5)).timeout
	animation.play("SwordAnimation/idle")
	await get_tree().create_timer(5.0).timeout
	animation.play("SwordAnimation/slice")
	await get_tree().create_timer(5.0).timeout
	animation.play("SwordAnimation/defend")
