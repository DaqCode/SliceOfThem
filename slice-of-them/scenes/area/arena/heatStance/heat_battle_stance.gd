class_name HeatBoy
extends Node2D

@onready var health_bar := $ProgressBar
@onready var health_text := $ProgressBar/HealthText

# Export variales for Heat depending on selected level, and their determined health and attack.
var health : int
var attack : int
var level : int

# Kept as a varaible for now. Nothing too serious, unless new phases or different styles of attacking
# These include waiting for a heavy attack, attempting to poison you, etc.
@export var special_ability : String
var max_health : int


func _ready() -> void:
	health = GlobalPlayerStats.base_health
	max_health = GlobalPlayerStats.base_health
	attack = GlobalPlayerStats.base_attack

	health_text.text = "%d" %health + " / " + "%d" %max_health  
	health_bar.max_value = max_health
	health_bar.value = health


	print("Enemy loaded - HP:", health, "ATK:", attack)


func take_damage(amount: int) -> void:
	health -= amount
	health = max(0, health)  # Ensure it never goes below 0

	# FORCE health bar and text to update
	if health_bar:
		health_bar.value = health
		health_text.text = "%d / %d" % [health, max_health]
	else:
		print("ERROR: Health bar not found in ", name)

	print(name, " took ", amount, " damage! Remaining HP: ", health)

	# Check if the enemy is dead
	if health <= 0:
		die()


func die() -> void:
	print(name, " has been defeated!")
	queue_free()  # Remove enemy from scene
