extends Control

@onready var staerieAnimation = $StaerieBob
@onready var staerieAnimationPlayer = $IdleBoy

func _ready() -> void:
    staerieAnimationPlayer.play("StaerieIdle")
    get_tree().create_timer(randi_range(10, 20)).timeout.connect(self.on_timer_timeout)

func on_timer_timeout() -> void:
    staerieAnimation.play("default")
    get_tree().create_timer(randi_range(10,20)).timeout.connect(self.on_timer_timeout)