extends Control

# Reference to the battle system
@export var battle_system: PackedScene

func _ready():
	for grid in get_children():
		if grid is GridContainer:
			for button in grid.get_children():
				if button is Button:
					button.pressed.connect(_on_level_selected.bind(button.battle_id))

func _on_level_selected(battle_id: int):
	GlobalBattleHandler.selected_battle_id = battle_id
	print("Battle ID stored in Global:", GlobalBattleHandler.selected_battle_id)  # Debug print
	get_tree().change_scene_to_file("res://scenes/area/arena/true_fight.tscn")

