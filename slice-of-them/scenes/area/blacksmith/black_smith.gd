extends Control

@onready var animation_player := $AnimationPlayer

# Base prices
var base_weapon_cost = 10
var base_cloud_cost = 10
var base_potion_cost = 5  # Potions start cheaper

# Scaling factor
var scaling_rate = 1.35

# Purchase counts
var sword_purchases = 0
var cloud_purchases = 0
var potion_purchases = 0

func _ready() -> void:

	print("Animation Player:", animation_player)

	$Map.connect("pressed", Callable(self, "_on_Map_Clicked"))

	print("Weapon Cost:", get_cost(base_weapon_cost, sword_purchases))
	print("Cloud Cost:", get_cost(base_cloud_cost, cloud_purchases))
	print("Potion Cost:", get_cost(base_potion_cost, potion_purchases))

	animation_player.stop()
	await get_tree().create_timer(0.1).timeout
	animation_player.play("Hammar")
	
# Function to calculate item cost based on purchases
func get_cost(base_price: float, num_purchases: int) -> int:
	return int(base_price * pow(scaling_rate, num_purchases))

# Function to purchase a sword
func purchase_sword() -> void:
	var cost = get_cost(base_weapon_cost, sword_purchases)
	if can_afford(cost):
		sword_purchases += 1
		print("Purchased Sword! New Cost:", get_cost(base_weapon_cost, sword_purchases))

# Function to purchase a cloud
func purchase_cloud() -> void:
	var cost = get_cost(base_cloud_cost, cloud_purchases)
	if can_afford(cost):
		cloud_purchases += 1
		print("Purchased Cloud! New Cost:", get_cost(base_cloud_cost, cloud_purchases))

# Function to purchase a potion
func purchase_potion() -> void:
	var cost = get_cost(base_potion_cost, potion_purchases)
	if can_afford(cost):
		potion_purchases += 1
		print("Purchased Potion! New Cost:", get_cost(base_potion_cost, potion_purchases))

# Dummy function for checking if player has enough currency
func can_afford(cost: int) -> bool:
	return true  # Replace with actual coin check

func _on_Map_Clicked() -> void:
	get_tree().change_scene_to_file("res://scenes/area/maps/map_direction.tscn")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print("Animation finished:", anim_name)  # Debugging line
	if anim_name == "Hammar":  # Ensure the name matches exactly
		var maybeSpin := randi_range(1, 10)
		if maybeSpin == 10:
			print("Playing SwingHammer.")
			animation_player.play("SwingHammer")
		else:
			print("Nooope. Go do it again, I guess idunno.")
			animation_player.play("Hammar")
	elif anim_name == "SwingHammer":
		animation_player.play("Hammar")
