class_name Enemy
extends Node2D

# Signal to notify when enemy is defeated
signal enemy_defeated

@onready var health_bar := $ProgressBar
@onready var health_text := $ProgressBar/HealthText

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
var enemy_max_hp: int

# Set variables to how many enemies, and their specific enemy textures
var current_enemy_index: int = 0
var enemy_list_array: Array


func _ready() -> void:
	enemy_hp = health  # Assign from exported variable
	enemy_max_hp = health
	enemy_atk = attack

	if sprite_texture:
		$EnemySprite.texture = sprite_texture  # Apply the texture
	
	health_text.text = "%d" % enemy_hp + " / " + "%d" % enemy_max_hp  
	health_bar.max_value = enemy_max_hp
	health_bar.value = enemy_hp
	print("Enemy loaded - HP:", enemy_hp, "ATK:", enemy_atk, "Level:", level)


func take_damage(amount: int) -> void:
	enemy_hp -= amount  # Reduce HP
	enemy_hp = max(enemy_hp, 0)  # Prevent negative HP

	# Update health bar and text
	health_bar.value = enemy_hp
	health_text.text = "%d / %d" % [enemy_hp, enemy_max_hp]

	# Print debug info
	print(name, " took ", amount, " damage! Remaining HP: ", enemy_hp)

	# Check if the enemy is dead
	if enemy_hp <= 0:
		emit_signal("enemy_defeated")


################################################################################################################
# Set up the battles when the areas are clicked.
func set_up_battle(current_battle_id: int) -> void:
	# Input in the match status for the selected_battle_id from the GlobalBattleIDGrabber whateverthingy stuff
	match current_battle_id:
		1:
			enemy_list_array = [
				{"health": 10, "attack": 1, "level": 1, "sprite_texture": preload("res://art/characters/enemy/Blothing_Decent.png")},  # Blothing is the first enemy
				{"health": 20, "attack": 4, "level": 3, "sprite_texture": preload("res://art/characters/enemy/Taknith_Decent.png")},   # Taknith is the second enemy
				{"health": 47, "attack": 8, "level": 5, "sprite_texture": preload("res://art/characters/enemy/Ovatrulant_Decent.png")}  # Ovatrulant is the last enemy
			]
		2:
			pass
		3:
			pass
		4:
			pass
		5:
			pass
		6:
			pass
		7:
			pass
		8:
			pass
		9:
			pass
		10:
			pass
		11:
			pass
		12:
			pass
		13:
			pass
		14:
			pass
		15:
			pass
		16:
			pass
		17:
			pass
		18:
			pass
		19:
			pass
		20:
			pass
		21:
			pass
		22:
			pass
		23:
			pass
		24:
			pass
		25:
			pass
		26:
			pass
		27:
			pass
		28:
			pass
		29:
			pass
		30:
			pass
		_:
			print("Not found")
	
	spawn_next_enemy()


func spawn_next_enemy() -> void:
	if current_enemy_index < enemy_list_array.size():
		var enemy_data = enemy_list_array[current_enemy_index]

		enemy_hp = enemy_data["health"]
		enemy_max_hp = enemy_hp

		enemy_atk = enemy_data["attack"] 
		level = enemy_data["level"]
		sprite_texture = enemy_data["sprite_texture"]

		$EnemySprite.texture = sprite_texture
		health_text.text = "%d / %d" % [enemy_hp, enemy_max_hp]
		health_bar.max_value = enemy_max_hp
		health_bar.value = enemy_hp

		print("Spawned enemy ", current_enemy_index + 1, " - HP:", enemy_hp, " ATK:", enemy_atk)
	else:
		print("You have finished and won the battle.")