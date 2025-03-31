extends Control

@onready var turn_label := $TurnCounter/TurnLabel

# Player Stats
var player_hp: int = GlobalPlayerStats.base_health
var player_atk: int = GlobalPlayerStats.base_attack

# Enemy Stats
# Pretty sure this is only to be different
# Needs to match with the right level, and types of enemy, and their other stuff.
var enemy_hp: int = 10
var enemy_atk: int = 1

# Turn Counter
var turn_counter: int = 0
var player_turn: bool = true  # Player starts first

func _ready() -> void:
	turn_label.text = "Turn: %d" %turn_counter
	print_status()
	print("-----------------------------------")
	await get_tree().create_timer(1.0).timeout
	print("Battle System Loaded, ID:", GlobalBattleHandler.selected_battle_id)  # Debug print
	start_battle(GlobalBattleHandler.selected_battle_id)

	
func player_attack() -> void:
	turn_counter += 1
	if player_turn:
		print("You attack the enemy for ", player_atk, " damage!")
		enemy_hp -= player_atk
		player_turn = false
		await get_tree().create_timer(1.0).timeout
		check_victory()

func enemy_attack() -> void:
	if not player_turn:
		print("The enemy attacks you for ", enemy_atk, " damage!")
		player_hp -= enemy_atk
		player_turn = true
		print_status()
		check_victory()

func check_victory() -> void:
	if enemy_hp <= 0:
		print("You defeated the enemy!")
		print("---------------------")
		# get_tree().quit()  # Replace with scene transition
	elif player_hp <= 0:
		print("You were defeated...")
		print("---------------------")
		# Make heat shake out of existence
		var tween := create_tween()
		var x_pos = $heatBattleStance.position.x  # Get current X position
		var y_pos = $heatBattleStance.position.y  # Get current Y position

		for i in range(10):  # 10 quick shakes
			var random_offset = Vector2(randf_range(-10, 10), randf_range(-10, 10))  # Random shake range
			tween.tween_property($heatBattleStance, "position", Vector2(x_pos, y_pos) + random_offset, 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

		# Fade out over 0.5s
		tween.parallel().tween_property($heatBattleStance, "modulate:a", 0.0, 0.5)

		# Queue free after effect
		await tween.finished
		$heatBattleStance.queue_free()

	else:
		await get_tree().create_timer(1.5).timeout
		if player_turn:
			turn_label.text = "Turn: %d" %turn_counter
			print("----------------------------------------")
			print("Player turn to strike!")
			player_turn = true
			player_attack()
		else:
			print("----------------------------------------")
			print("Enemy turn to strike!")
			player_turn = false
			enemy_attack()

func print_status() -> void:
	print("\n--- Battle Status ---")
	print("Player HP:", player_hp)
	print("Enemy HP:", enemy_hp)
	print("---------------------")

################################################################################################################################

# Match specific battle systems.

func start_battle(selected_battle_id: int):
	print("Battle System Received ID:", selected_battle_id)
	
	match selected_battle_id:
		1:
			var enemies = [
				"Blothing",
				"Taknith",
				"Ovatrulant"
			]
			print(enemies)

			

		_:
			print("Unknown battle ID:", selected_battle_id)

	player_attack()
