extends Control

@onready var stat_change := $StatContainer/CharStats/Indicator/WhatStatChange
@onready var stat_change_numerical := $StatContainer/CharNumStats/NumberStats

# When first entering, update the stats.
func _ready() -> void:
	stat_change_numerical.text = str(GlobalPlayerStats.base_health) + "\n" + str(GlobalPlayerStats.base_attack) + "\n" + "% "+str(GlobalPlayerStats.block_chance) + "\n" + "% "+ str(GlobalPlayerStats.block_amount_percent) + "\n" + "% "+str(GlobalPlayerStats.dodge_chance) + "\n" + "% "+str(GlobalPlayerStats.crit_stat) + "\n"+"% "+str(GlobalPlayerStats.crit_multiplier)


# Increase stats when pressed and you have enough of the skillpoints/levels.
func _on_health_pressed() -> void:
	GlobalPlayerStats.increase_health(14)
	_change_number_values()
	_on_health_mouse_entered()

func _on_attack_pressed() -> void:
	GlobalPlayerStats.increase_attack(14)
	_change_number_values()
	_on_attack_mouse_entered()

func _on_agility_pressed() -> void:
	GlobalPlayerStats.increase_agility(14)
	_change_number_values()
	_on_agility_mouse_entered()

func _on_defense_pressed() -> void:
	GlobalPlayerStats.increase_defense(14)
	_change_number_values()
	_on_defense_mouse_entered()

func _on_crit_pressed() -> void:
	GlobalPlayerStats.increase_crit(14)
	_change_number_values()
	_on_crit_mouse_entered()


# Show the text below the the buttons.
func _on_health_mouse_entered() -> void:
	stat_change.text = "Health: %s" % GlobalPlayerStats.base_health + " -> %s"	% (GlobalPlayerStats.base_health+14)

func _on_attack_mouse_entered() -> void:
	stat_change.text = "Attack: %s" % GlobalPlayerStats.base_attack + " -> %s"	% (GlobalPlayerStats.base_attack+14)

func _on_agility_mouse_entered() -> void:
	stat_change.text = "Agility: %s" % GlobalPlayerStats.agility_stat + " -> %s"	% (GlobalPlayerStats.agility_stat+14)	

func _on_defense_mouse_entered() -> void:
	stat_change.text = "Defense: %s"	% GlobalPlayerStats.defense + " -> %s"	% (GlobalPlayerStats.defense+14)

func _on_crit_mouse_entered() -> void:
	stat_change.text = "Crit: %s" % GlobalPlayerStats.crit_stat + " -> %s"	% (GlobalPlayerStats.crit_stat+14)

# Updates the text of the stat_change_numerical every time there's a function called out for the text.
func _change_number_values() -> void:
	stat_change_numerical.text = str(GlobalPlayerStats.base_health) + "\n" + str(GlobalPlayerStats.base_attack) + "\n" + "% "+str(GlobalPlayerStats.block_chance) + "\n" + "% "+ str(GlobalPlayerStats.block_amount_percent) + "\n" + "% "+str(GlobalPlayerStats.dodge_chance) + "\n" + "% "+str(GlobalPlayerStats.crit_stat) + "\n"+"% "+str(GlobalPlayerStats.crit_multiplier)
