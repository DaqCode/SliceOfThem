extends Control

# Player Stats
var player_hp: int = GlobalPlayerStats.base_health
var player_atk: int = GlobalPlayerStats.base_attack

# Enemy Stats
var enemy_hp: int = 10
var enemy_atk: int = 1

var player_turn: bool = true  # Player starts first

func _ready() -> void:
	print_status()
	await get_tree().create_timer(1.0).timeout
	player_attack()
	
func player_attack() -> void:
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
		# get_tree().quit()  # Replace with game over
	else:
		print("Nothing happened because you are both still alive. CONTINUE")
		await get_tree().create_timer(1.5).timeout
		if player_turn:
			player_turn = true
			player_attack()
		else:
			player_turn = false
			enemy_attack()

func print_status() -> void:
	print("\n--- Battle Status ---")
	print("Player HP:", player_hp)
	print("Enemy HP:", enemy_hp)
	print("---------------------")
