extends Control

@onready var turn_label := $TurnCounter/TurnLabel
@onready var current_enemy := $Enemy
@onready var heatBoyo := $heatBattleStance

# Player Stats
var player_hp: int = GlobalPlayerStats.base_health
var player_atk: int = GlobalPlayerStats.base_attack

# Enemy Stats
# Pretty sure this is only to be different
# Needs to match with the right level, and types of enemy, and their other stuff.
var enemy_hp: int
var enemy_atk: int 

# Turn Counter
var turn_counter: int = 0
var player_turn: bool = true  # Player starts first

func _ready() -> void:
	turn_label.text = "Turn: %d" %turn_counter
	print_status()
	print("-----------------------------------")
	await get_tree().create_timer(1.0).timeout
	print("Battle System Loaded, ID:", GlobalBattleHandler.selected_battle_id)  # Debug print
	
	# Ensure enemy stats are set up before starting the battle
	current_enemy.set_up_battle(GlobalBattleHandler.selected_battle_id)
	
	# Now start the battle after the setup is done
	start_battle(GlobalBattleHandler.selected_battle_id)

	# Connect the signal for enemy death update
	GlobalBattleHandler.connect("updated_new_enemy_spawns", Callable(self, "_on_enemy_died"))


# Signal handler function
func _on_enemy_died(enemy_health, enemy_attack):
	# Update the enemy's health and attack based on the signal data
	enemy_hp = enemy_health
	enemy_atk = enemy_attack
	print("Updated enemy stats: HP: %d, Attack: %d" % [enemy_hp, enemy_atk])

	# Removed check_victory call from here as it was breaking the loop

func start_battle(selected_battle_id: int) -> void:
	print("Battle System Received ID:", selected_battle_id)
	current_enemy.set_up_battle(GlobalBattleHandler.selected_battle_id)
	enemy_hp = current_enemy.enemy_hp
	enemy_atk = current_enemy.enemy_atk

	# Just trigger the battle flow without breaking on initial attack
	# player_attack()

# Removed player_attack function as it causes flow issues in turn-based logic

# Removed enemy_attack function as it messes up the flow

func check_victory() -> void:
	# Victory check moved here
	if enemy_hp <= 0:
		print("You defeated the enemy!")
		print("---------------------")

		#NEEDS TO SUMMON NEW ENEMY, UNLESS THATS WHAT THE ENMY ALREADY DOES FOR SOME REASON?
		GlobalBattleHandler._on_updated_new_enemy_spawns(current_enemy.health, current_enemy.attack)
		return

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
		# Removed redundant calls to start the next turn here
		# The victory check will now correctly reset the state and let the battle loop continue.
		turn_label.text = "Turn: %d" %turn_counter
		print("----------------------------------------")
		print("Player turn to strike!")
		player_turn = true
		# player_attack()  # Trigger the player attack flow to avoid breaking sequence

func print_status() -> void:
	print("\n--- Battle Status ---")
	print("Player HP:", player_hp)
	print("Enemy HP:", enemy_hp)
	print("---------------------")
	print("Player Attack:", player_atk)
	print("Enemy Attkack:", enemy_atk)
	print("---------------------")


func reset_turn_to_player() -> void:
	print("New enemy spawned! Resetting turn to player!")
	player_turn = true  # Force it to be the player's turn
	turn_label.text = "Turn: %d" % turn_counter
	await get_tree().create_timer(0.75).timeout
	# player_attack()


################################################################################################################################
# Mental notes
# Once battle begins, the ready should automatically direct to start battle
# Grab the battle id found by clicking whichever banner
# Then the match statement should get specific enemies with their individualized stats (Meaning this might need a [][]? Not too sure how this will have to be put)
# The problem here is that the variables has to change multipel times
# There also has to be a check to whetehr the enemy is dead or not, and when it does die, it should just switch to the next enemy
# in the array with those specified stats.
#
# Other than that, if thats finished, then the entire gameplay loop would be done
# But the other problem then becomes the training part.
# I think the docs should be able to reference these topics, but will have to be let alone for now.
