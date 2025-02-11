extends Node2D

@export var speed: float = 5000  # Adjust speed as needed
@export var direction: Vector2 = Vector2.RIGHT  # Default direction

func _process(delta: float) -> void:
	position += direction * speed * delta  # Move the bullet

	# Remove if it goes off-screen
	if not get_viewport_rect().has_point(global_position):
		queue_free()
