extends Node

# Signal to notify when an enemy has died
signal updated_new_enemy_spawns(enemy_health, enemy_attack)

var selected_battle_id: int = 0
var next_enemy_health: int = 0
var next_enemy_attack: int = 0

func _ready() -> void:
	connect("updated_new_enemy_spawns", Callable(self, "_on_updated_new_enemy_spawns"))

func _on_updated_new_enemy_spawns(enemy_health: int, enemy_attack: int) -> void:
	next_enemy_health = enemy_health
	next_enemy_attack = enemy_attack
# func Object.connect(signal: StringName, callable: Callable, flags: int = 0) -> int