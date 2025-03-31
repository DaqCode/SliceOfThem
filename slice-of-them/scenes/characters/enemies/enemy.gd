class_name Enemy
extends Node2D

# Export variales for the enemies depending on selected level, and the actual type of enemies
@export var health : int
@export var attack : int
@export var level : int
@export var sprite_texture: Texture  # Allows texture assignment in the Inspector

# Kept as a varaible for now. Nothing too serious, unless new phases or different styles of attacking
# These include waiting for a heavy attack, attempting to poison you, etc.
@export var special_ability : String

# Local variables to store instance stats
var enemy_hp: int
var enemy_atk: int

func _ready():
	enemy_hp = health  # Assign from exported variable
	enemy_atk = attack

	if sprite_texture:
		$EnemySprite.texture = sprite_texture  # Apply the texture

	print("Enemy loaded - HP:", enemy_hp, "ATK:", enemy_atk, "Level:", level)
