extends Control

@onready var animation_player := $AnimationPlayer

# Base prices
var base_weapon_cost = 10
var base_cloud_cost = 10
var base_potion_cost = 10  # Potions start cheaper

# Remember that his needs to be tracked by a global, because otherwise, tis always gonna start at 10 and forever just stay cheap :P
var current_potion_costs : int = 10

# Scaling factor
var scaling_rate = 4.75

# Purchase counts
var sword_purchases = 0
var cloud_purchases = 0
var potion_purchases = 0

# Cloud and Sword Purcahse Text
@onready var sword_name_label := $Sword/SwordPurchase
@onready var sword_cost_label := $Sword/SwordPrice
@onready var cloud_name_label := $Cloud/CloudPurchase
@onready var cloud_cost_label := $Cloud/CloudPrice


# Cloud to show the temp items
@onready var potion_show_image := $ShowThePotionFloat

# Cloud and Sword Tween variables
@onready var cloud_image := $Cloud/CloudImage
@onready var sword_image := $Sword/SwordImage
@onready var the_entire_stats := $ShowThePotionFloat

var cloud_origin_position: Vector2
var cloud_origin_scale: Vector2
var sword_base_modulate: Color

# More checks for whatever i dunno :|
var is_mouse_inside: bool

# Voice lines for Gaze
var voice_sample: Array = [
	preload("res://art/sounds/voiceLines/hello1.mp3"),
	preload("res://art/sounds/voiceLines/hello2.mp3"),
	preload("res://art/sounds/voiceLines/hello3.mp3")

]

func _ready() -> void:
	$WelkomeIn.stream = voice_sample[randi_range(0,2)]
	if ($WelkomeIn.stream == voice_sample[2]):
		$WelkomeIn.volume_db = -5
		$WelkomeIn.play()
	else:
		$WelkomeIn.volume_db = -12.5
		$WelkomeIn.play()
	print("Animation Player:", animation_player)

	$Map.connect("pressed", Callable(self, "_on_Map_Clicked"))

	print("Weapon Cost:", get_cost(base_weapon_cost, sword_purchases))
	print("Cloud Cost:", get_cost(base_cloud_cost, cloud_purchases))
	print("Potion Cost:", get_cost(base_potion_cost, potion_purchases))

	# Purchase sword and cloud upgrades perma
	update_sword_offer()
	update_cloud_offer()

	$Signs/SignCost.text = str(current_potion_costs)
	# Cloud tween keep
	cloud_origin_position = cloud_image.position
	cloud_origin_scale = cloud_image.scale
	sword_base_modulate = sword_image.modulate

	animate_cloud()
	animate_sword()

	animation_player.stop()
	await get_tree().create_timer(0.1).timeout
	animation_player.play("Hammar")


	# Create the signals for mouse entered and mouse exited for all the buttons.

	$UseItems/HealPoion.connect("mouse_entered", Callable(self, "_on_heal_mouse_entered"))
	$UseItems/HealPoion.connect("mouse_exited", Callable(self, "_on_heal_mouse_exited"))

	$UseItems/StrengthPotion.connect("mouse_entered", Callable(self, "_on_strength_mouse_entered"))
	$UseItems/StrengthPotion.connect("mouse_exited", Callable(self, "_on_strength_mouse_exited"))

	$UseItems/FlamePotion.connect("mouse_entered", Callable(self, "_on_flame_mouse_entered"))
	$UseItems/FlamePotion.connect("mouse_exited", Callable(self, "_on_flame_mouse_exited"))

	$UseItems/SpeedPotion.connect("mouse_entered", Callable(self, "_on_speed_mouse_entered"))
	$UseItems/SpeedPotion.connect("mouse_exited", Callable(self, "_on_speed_mouse_exited"))

	$UseItems/RefreshPotion.connect("mouse_entered", Callable(self, "_on_refresh_mouse_entered"))
	$UseItems/RefreshPotion.connect("mouse_exited", Callable(self, "_on_refresh_mouse_exited"))

	$UseItems/LuckPotion.connect("mouse_entered", Callable(self, "_on_luck_mouse_entered"))
	$UseItems/LuckPotion.connect("mouse_exited", Callable(self, "_on_luck_mouse_exited"))

	$DarknessPotion.connect("mouse_entered", Callable(self, "_on_dark_mouse_entered"))
	$DarknessPotion.connect("mouse_exited", Callable(self, "_on_dark_mouse_exited"))

	# Create connect signals to connect pressed because i realized too late.
	$Sword/SwordPurchase.connect("pressed", Callable(self, "_on_sword_pressed"))
	$Cloud/CloudPurchase.connect("pressed", Callable(self, "_on_cloud_pressed"))
	$UseItems/HealPoion.connect("pressed", Callable(self, "_on_heal_pressed"))
	$UseItems/StrengthPotion.connect("pressed", Callable(self, "_on_strength_pressed"))
	$UseItems/FlamePotion.connect("pressed", Callable(self, "_on_flame_pressed"))
	$UseItems/SpeedPotion.connect("pressed", Callable(self, "_on_speed_pressed"))
	$UseItems/RefreshPotion.connect("pressed", Callable(self, "_on_refresh_pressed"))
	$UseItems/LuckPotion.connect("pressed", Callable(self, "_on_luck_pressed"))
	$DarknessPotion.connect("pressed", Callable(self, "_on_dark_pressed"))

	
	# Update the amount of potions the player has below the potion buying part
	update_potion_amount_inventory()
####################
#Mental note to self
# Split each of the potions to 3
# Darkness potion is to only be unlocked after certain criterias, and also maek it so that it's basically going to be uhhhhhhhhhhh whats the word
# Make it unlocked unil specific certiera is met.
# Make it maybe available after you fix up Glotch and his bridge. 

# Shit, you know what, maybe make the storyline for the bridge glotch's story.


# Function to calculate item cost based on purchases
func get_cost(base_price: float, num_purchases: int) -> int:
	return int(base_price * pow(scaling_rate, num_purchases))

func get_potion_cost(potion_cost_initial: int, how_many_purchase_potion: int) -> int:
	return int(potion_cost_initial * pow(1.08, how_many_purchase_potion))

func update_sword_offer():
	var next_upgrade = GlobalPlayerStats.sword_upgrade_number + 1

	var sword_names = [
		"Wood Sword", "Bronze Sword", "Iron Sword", "Diamond Sword",
		"Vampire Blade", "Shiver Sword", "Double Shadow Spear",
		"Void’s Cleaver", "Crystalized Sword",
		"Shocked Dagger", "Rainbow Sword", "Staerie’s Last Hope"
	]

	var sword_paths = [
		preload("res://art/swords/BronzeSword/BronzeSword.png"),    
		preload("res://art/swords/IronSword/IronSword.png"),
		preload("res://art/swords/DiamondSword/DiamondSword.png"),
		preload("res://art/swords/VampireBlade/VampireBlade.png"),
		preload("res://art/swords/ShiverSword/SaphireSword.png"),
		preload("res://art/swords/DoubleShadowSpear/ShadowSides.png"),
		preload("res://art/swords/VoidsCleaver/VoidsCleaver.png"),
		preload("res://art/swords/CrystalizedSword/CrystalSword.png"),
		preload("res://art/swords/ShockedDagger/ShockedDagger.png"),
		preload("res://art/swords/RainbowSword/RainbowSword.png"),
		preload("res://art/swords/StaerieLastHope/StaerieLastHope.png"),
		preload("res://art/swords/white.png")
	]

	$Sword/SwordImage.texture = sword_paths[GlobalPlayerStats.sword_upgrade_number]

	if next_upgrade >= sword_names.size():
		sword_name_label.text = "MAX LEVEL"
		sword_cost_label.text = "—"
		# Disable the button when max level is reached
		$Sword/SwordPurchase.disabled = true
	else:
		sword_name_label.text = "Upgrade to " + sword_names[next_upgrade]
		var cost = get_cost(base_weapon_cost, sword_purchases)
		sword_cost_label.text = "Price: " + str(cost) + " 🪙"
		# Enable the button if not at max level
		$Sword/SwordPurchase.disabled = false


func update_cloud_offer():
	var next_upgrade = GlobalPlayerStats.cloud_upgrade_number + 1

	var cloud_names = [
		"Droopy Cloud", "Fluffy Cloud", "Pillow Cloud", "Fluffier Cloud",
		"Nimbus Cloud", "Fire Cloud", "Iron Cloud",
		"Rainbow Cloud", "Stardrop Cloud", "Neutron Cloud",
		"Staerie’s Resting Cloud"
	]

	var cloud_texture = [
		preload("res://art/clouds/FluffyCloud.png"),
		preload("res://art/clouds/PillowCloud.png"),
		preload("res://art/clouds/FluffierCloud.png"),
		preload("res://art/clouds/NimbusCloud.png"),
		preload("res://art/clouds/FlameCloud_Decent.png"),
		preload("res://art/clouds/IronCloud.png"),
		preload("res://art/clouds/RainbowCloud.png"),
		preload("res://art/clouds/StarDropCloud.png"),
		preload("res://art/clouds/NeutronCloud.png"),
		preload("res://art/clouds/StarThrone.png"),
		preload("res://art/swords/white.png")
	]

	$Cloud/CloudImage.texture = cloud_texture[GlobalPlayerStats.cloud_upgrade_number]

	if next_upgrade >= cloud_names.size():
		cloud_name_label.text = "MAX LEVEL"
		cloud_cost_label.text = "—"
		$Cloud/CloudPurchase.disabled = true  
	else:
		cloud_name_label.text = "Upgrade to " + cloud_names[next_upgrade]
		var cost = get_cost(base_cloud_cost, cloud_purchases)
		cloud_cost_label.text = "Price: " + str(cost) + " 🪙"
		$Cloud/CloudPurchase.disabled = false  

# Function to purchase a sword
func purchase_sword() -> void:
	var cost = get_cost(base_weapon_cost, sword_purchases)
	if can_afford(cost):
		GlobalPlayerStats.coins -= cost
		sword_purchases += 1
		GlobalPlayerStats.sword_upgrade_number += 1
		print("Purchased Sword! New Cost:", get_cost(base_weapon_cost, sword_purchases))
		update_sword_offer()


# Function to purchase a cloud
func purchase_cloud() -> void:
	var cost = get_cost(base_cloud_cost, cloud_purchases)
	if can_afford(cost):
		GlobalPlayerStats.coins -= cost
		cloud_purchases += 1
		GlobalPlayerStats.cloud_upgrade_number += 1
		print("Purchased Cloud! New Cost:", get_cost(base_cloud_cost, cloud_purchases))
		update_cloud_offer()

# Function to purchase a potion
func purchase_potion(potion_type: String) -> void:
	var cost = get_potion_cost(base_potion_cost, potion_purchases)
	current_potion_costs = cost
	$Signs/SignCost.text = str(current_potion_costs)
	match potion_type:
			"heal":
				if GlobalPlayerStats.how_many_health == 3:
					$UseItems/HealPoion.disabled = true
					print("You went over the limit. You now have a lot of potions. How many? %d" %GlobalPlayerStats.how_many_health)
					return
			"strength":
				if GlobalPlayerStats.how_many_strenght == 3:
					$UseItems/StrengthPotion.disabled = true
					print("You went over the limit. You now have a lot of potions. How many? %d" %GlobalPlayerStats.how_many_strenght)
					return
			"flame":
				if GlobalPlayerStats.how_many_flame == 3:
					$UseItems/FlamePotion.disabled = true
					print("You went over the limit. You now have a lot of potions. How many? %d" %GlobalPlayerStats.how_many_flame)
					return
			"speed":
				if GlobalPlayerStats.how_many_speed == 3:
					$UseItems/SpeedPotion.disabled = true
					print("You went over the limit. You now have a lot of potions. How many? %d" %GlobalPlayerStats.how_many_speed)
					return
			"refresh":
				if GlobalPlayerStats.how_many_refresh == 3:
					$UseItems/RefreshPotion.disabled = true
					print("You went over the limit. You now have a lot of potions. How many? %d" %GlobalPlayerStats.how_many_refresh)
					return
			"luck":
				if GlobalPlayerStats.how_many_luck == 3:
					$UseItems/LuckPotion.disabled = true
					print("You went over the limit. You now have a lot of potions. How many? %d" %GlobalPlayerStats.how_many_luck)
					return
			"dark":
				if GlobalPlayerStats.how_many_darkness == 2:
					$DarknessPotion.disabled = true
					print("You went over the limit. You now have a lot of potions. How many? %d" %GlobalPlayerStats.how_many_darkness)
					return
			_:
				print("Lol no.")

	if can_afford(cost):
		GlobalPlayerStats.coins -= cost
		potion_purchases += 1
		match potion_type:
			"heal":
				GlobalPlayerStats.how_many_health +=1
			"strength":
				GlobalPlayerStats.how_many_strenght +=1
			"flame":
				GlobalPlayerStats.how_many_flame +=1
			"speed":
				GlobalPlayerStats.how_many_speed +=1
			"refresh":
				GlobalPlayerStats.how_many_refresh +=1
			"luck":
				GlobalPlayerStats.how_many_luck +=1
			"dark":
				GlobalPlayerStats.how_many_darkness +=1
			_:
				print("Lol no.")
		update_potion_amount_inventory()
		print("Purchased Potion! New Cost:", cost)

func can_afford(cost: int) -> bool:
	return GlobalPlayerStats.coins >= cost

func _on_Map_Clicked() -> void:
	get_tree().change_scene_to_file("res://scenes/area/maps/map_direction.tscn")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Hammar":  # Ensure the name matches exactly
		var maybeSpin := randi_range(1, 100)
		if maybeSpin == 100:

			animation_player.play("SwingHammer")
		else:
			animation_player.play("Hammar")
	elif anim_name == "SwingHammer":
		animation_player.play("Hammar")

func animate_cloud():
	var tween = create_tween()
	
	# Random 5-10 pixel offset in both directions
	var offset_x = randi_range(-10, 10)
	offset_x = offset_x if abs(offset_x) >= 5 else (5 if offset_x >= 0 else -5)
	
	var offset_y = randi_range(-10, 10)
	offset_y = offset_y if abs(offset_y) >= 5 else (5 if offset_y >= 0 else -5)
	
	var target_pos = cloud_origin_position + Vector2(offset_x, offset_y)
	
	# Random scale between 0.9 and 1.1
	var target_scale = cloud_origin_scale * randf_range(0.9, 1.1)

	# Duration
	var duration = randf_range(0.6, 1.2)

	tween.tween_property(cloud_image, "position", target_pos, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(cloud_image, "scale", target_scale, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.connect("finished", Callable(self, "animate_cloud"))

func animate_sword():
	var tween = create_tween()
	
	# Flash red fast
	tween.tween_property(sword_image, "modulate", Color(1, 0.3, 0.3), 0.125)	
	
	# Then cool down slow
	tween.tween_property(sword_image, "modulate", sword_base_modulate, 1.75).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	tween.connect("finished", Callable(self, "animate_sword"))

func _on_sword_pressed() -> void:
	print("SWORD PURCHASE ATTEMPTED!")
	purchase_sword()

func _on_cloud_pressed() -> void:
	print("CLOUD PURCHASE ATTEMPTED!")
	purchase_cloud()

#####################################################################################################################################################################
# Preload your potion textures.
var heal_texture: Texture2D = preload("res://art/drinkable/HealthPotion.png")
var strength_texture: Texture2D = preload("res://art/drinkable/StrengthPotion.png")
var flame_texture: Texture2D = preload("res://art/drinkable/FirePotion.png")
var speed_texture: Texture2D = preload("res://art/drinkable/SpeedPotion.png")
var refresh_texture: Texture2D = preload("res://art/drinkable/ReturnPotion.png")
var luck_texture: Texture2D = preload("res://art/drinkable/LuckPotion.png")
var darkness_texture: Texture2D = preload("res://art/drinkable/DarknessPotion.png")

# The check to make sure that the bug doesn't appear  with the cloud appearing.
var have_you_been_hovering: bool = false
var is_cloud_already_visible: bool = false

# Potion button event functions.
func _on_heal_mouse_entered() -> void:
	the_entire_stats.show_cloud(heal_texture, "Potion of Heal", "Heals player for 25% of their health.")

func _on_heal_mouse_exited() -> void:	
		the_entire_stats.hide_cloud()

func _on_strength_mouse_entered() -> void:
	have_you_been_hovering = true

	the_entire_stats.show_cloud(strength_texture, "Potion of Strength", "Strengthens player for 2 turns to do x1.5 damage.")

func _on_strength_mouse_exited() -> void:
	the_entire_stats.hide_cloud()

func _on_flame_mouse_entered() -> void:
	the_entire_stats.show_cloud(flame_texture, "Potion of Fire", "Burns enemy. When burned, enemy will take 10% of their health every turn.")

func _on_flame_mouse_exited() -> void:
	the_entire_stats.hide_cloud()

func _on_speed_mouse_entered() -> void:
	the_entire_stats.show_cloud(speed_texture, "Potion of Speed", "Player has a 50% chance to dodge attacks for 4 turns.")

func _on_speed_mouse_exited() -> void:
	the_entire_stats.hide_cloud()

func _on_refresh_mouse_entered() -> void:
	the_entire_stats.show_cloud(refresh_texture, "Potion of Refresh", "Player will reduce cooldowns of abilities by 4 turns for the current turn.")

func _on_refresh_mouse_exited() -> void:
	the_entire_stats.hide_cloud()

func _on_luck_mouse_entered() -> void:
	the_entire_stats.show_cloud(luck_texture, "Potion of Luck", "One of the 5 potion effects, except darkness, will be triggered at random.")

func _on_luck_mouse_exited() -> void:
	the_entire_stats.hide_cloud()

func _on_dark_mouse_entered() -> void:
	the_entire_stats.show_cloud(darkness_texture, "Potion of Darkness", "Obtain the power of Glotch. All hits will burn and deal 3x damage. However, you will die in 3 turns.")

func _on_dark_mouse_exited() -> void:
	the_entire_stats.hide_cloud()

func _on_heal_pressed() -> void:
	print("Purchased Heal Potion")
	purchase_potion("heal")

func _on_strength_pressed() -> void:
	print("Purchased Strength Potion")
	purchase_potion("strength")

func _on_flame_pressed() -> void:
	print("Purchased Flame Potion")
	purchase_potion("flame")

func _on_speed_pressed() -> void:
	print("Purchased Speed Potion")
	purchase_potion("speed")

func _on_refresh_pressed() -> void:
	print("Purchased Refresh Potion")
	purchase_potion("refresh")

func _on_luck_pressed() -> void:
	print("Purchased Luck Potion")
	purchase_potion("luck")

func _on_dark_pressed() -> void:
	print("Purchased Darkness Potion")
	purchase_potion("dark")

func check_for_being_hovered() -> void:
	pass

func update_potion_amount_inventory() -> void:
	for potion in $UseItems.get_children():
		for child in potion.get_children():
			if child.name.begins_with("AmountInInventory") and child is Label:
				match child.name:
					"AmountInInventory1":
						$UseItems/HealPoion/AmountInInventory1.text = str(GlobalPlayerStats.how_many_health)
					"AmountInInventory2":
						$UseItems/StrengthPotion/AmountInInventory2.text = str(GlobalPlayerStats.how_many_strenght)
					"AmountInInventory3":
						$UseItems/FlamePotion/AmountInInventory3.text = str(GlobalPlayerStats.how_many_flame)
					"AmountInInventory4":
						$UseItems/SpeedPotion/AmountInInventory4.text = str(GlobalPlayerStats.how_many_speed)
					"AmountInInventory5":
						$UseItems/RefreshPotion/AmountInInventory5.text = str(GlobalPlayerStats.how_many_refresh)
					"AmountInInventory6":
						$UseItems/LuckPotion/AmountInInventory6.text = str(GlobalPlayerStats.how_many_luck)
					"AmountInInventory7":
						$DarknessPotion/AmountInInventory7.text = str(GlobalPlayerStats.how_many_darkness)
					_:
						print("What in the hell did you manage to get to do to get this damn print statement.")

func update_if_you_can_even_afford_item () -> void:
	pass
	#Seems to be updating even if you press it. Disable he button if you cant even buy it in the first plcae.

##############################################################################################################################
# For the funny goofy click.

func _input(event: InputEvent) -> void:
	if is_mouse_inside and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			get_tree().change_scene_to_file("res://scenes/area/blacksmith/why_did_you_touch.tscn")


func _on_hammer_no_touch_area_mouse_entered() -> void:
	is_mouse_inside = true

func _on_hammer_no_touch_area_mouse_exited() -> void:
	is_mouse_inside = false

