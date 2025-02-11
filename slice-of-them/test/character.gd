extends Node2D

@onready var bullet_scene = preload("res://test/idea_bullet.tscn")  # Load bullet scene
@onready var ammo_ui = $SwordAmmo  # Adjust path as needed to reference your ammo UI

var can_shoot = true  # Ensures shooting only happens when ammo is available

func _ready() -> void:
	if ammo_ui:
		ammo_ui.connect("ammo_used", Callable(self, "_shoot"))

func _shoot() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = self.global_position  # Spawn at character's position
	bullet.direction = Vector2.RIGHT  # Modify direction as needed
	get_parent().add_child(bullet)  # Add bullet to scene

	# Prevent shooting if ammo is 0 (handled by ammo UI)
	if ammo_ui.ammo_count == 0:
		can_shoot = false
		await get_tree().create_timer(2).timeout  # Wait for ammo reload
		can_shoot = true  #
