extends Control

@onready var stat_change := $StatContainer/CharStats/Indicator/WhatStatChange
@onready var stat_change_numerical := $StatContainer/CharNumStats/NumberStats

func _ready() -> void:
	# Connect the global stats signal to update the UI automatically.
	GlobalPlayerStats.connect("stats_updated", Callable(self, "_change_number_values"))
	
	# Initial update of the UI text.
	_change_number_values()

# Increase stats when pressed (example buttons)
func _on_health_pressed() -> void:
	GlobalPlayerStats.increase_health(14)
	_on_health_mouse_entered()

func _on_attack_pressed() -> void:
	GlobalPlayerStats.increase_attack(30)
	_on_attack_mouse_entered()

func _on_agility_pressed() -> void:
	GlobalPlayerStats.increase_agility(3)
	_on_agility_mouse_entered()

func _on_defense_pressed() -> void:
	GlobalPlayerStats.increase_defense(10)
	_on_defense_mouse_entered()

func _on_crit_pressed() -> void:
	GlobalPlayerStats.increase_crit(2)
	_on_crit_mouse_entered()

# Show the text below the buttons (when mouse enters)
func _on_health_mouse_entered() -> void:
	stat_change.text = "Health: %s" % GlobalPlayerStats.base_health + " -> %s" % (GlobalPlayerStats.base_health+14)

func _on_attack_mouse_entered() -> void:
	stat_change.text = "Attack: %s" % GlobalPlayerStats.base_attack + " -> %s" % (GlobalPlayerStats.base_attack+14)

func _on_agility_mouse_entered() -> void:
	stat_change.text = "Agility: %s" % GlobalPlayerStats.agility_stat + " -> %s" % (GlobalPlayerStats.agility_stat+14)

func _on_defense_mouse_entered() -> void:
	stat_change.text = "Defense: %s" % GlobalPlayerStats.defense + " -> %s" % (GlobalPlayerStats.defense+14)

func _on_crit_mouse_entered() -> void:
	stat_change.text = "Crit: %s" % GlobalPlayerStats.crit_stat + " -> %s" % (GlobalPlayerStats.crit_stat+14)

# Update the numerical stats display
func _change_number_values() -> void:
	stat_change_numerical.text = (
		"%d\n%d\n%% %.2f\n%% %.2f\n%% %.2f\n%% %.2f\n%% %.2f" % [
			GlobalPlayerStats.base_health,
			GlobalPlayerStats.base_attack,
			GlobalPlayerStats.block_chance,
			GlobalPlayerStats.block_amount_percent,
			GlobalPlayerStats.dodge_chance,
			GlobalPlayerStats.crit_chance,
			GlobalPlayerStats.crit_multiplier
		]
	)
