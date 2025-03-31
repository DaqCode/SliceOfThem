extends "res://resources/sword/BaseSword.gd"

@onready var animation : AnimationPlayer = $AnimationControl

func _ready() -> void:
    var animations = ["idle", "slice", "defend"]
    animation.speed_scale = 1.25
    var current_animation = 0

    while true:
        animation.play("SwordAnimation/" + animations[current_animation])
        await get_tree().create_timer(2.0).timeout
        current_animation = (current_animation + 1) % animations.size()
