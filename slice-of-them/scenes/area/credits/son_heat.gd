extends Control

const MIN_CAMERA_X = 591
const MAX_CAMERA_X = 2375
const CAMERA_SPEED = 1000.0

var move_left = false
var move_right = false

func _ready() -> void:
	# Connect signals for each collision area
	$Camera2D/Left.connect("mouse_entered", Callable(self, "_on_left_mouse_entered"))
	$Camera2D/Left.connect("mouse_exited", Callable(self, "_on_left_mouse_exited"))

	$Camera2D/Right.connect("mouse_entered", Callable(self, "_on_right_mouse_entered"))
	$Camera2D/Right.connect("mouse_exited", Callable(self, "_on_right_mouse_exited"))

func _physics_process(delta: float) -> void:
	if move_left:
		$Camera2D.position.x -= CAMERA_SPEED * delta
	elif move_right:
		$Camera2D.position.x += CAMERA_SPEED * delta

	# Clamp the camera's x-position so it doesn't go beyond your defined range
	$Camera2D.position.x = clamp($Camera2D.position.x, MIN_CAMERA_X, MAX_CAMERA_X)


# Called when mouse enters/exits the LeftCollisionArea
func _on_left_mouse_entered() -> void:
	print("left mouse entered")
	move_left = true

func _on_left_mouse_exited() -> void:
	print("left mouse exited")
	move_left = false


# Called when mouse enters/exits the RightCollisionArea
func _on_right_mouse_entered() -> void:
	print("right mouse entered")
	move_right = true

func _on_right_mouse_exited() -> void:
	print("right mouse exited")
	move_right = false
