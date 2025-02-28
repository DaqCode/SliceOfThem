extends Control

@onready var stat_change := $StatContainer/CharStats/Indicator/WhatStatChange
@onready var stat_change_numerical := $StatContainer/CharNumStats/NumberStats

# Dictionary for the tooltips.
var skill_data = {
	"Poison Bottle": {
		"name": "Poison Bottle",
		"description": "The last one. That was made without any instructions.",
		"tooltip":"Throw a bottle of poison at the enemy. ",
		"use": "Lasts 3 turns, takes 6 turns to replenish."
	},
	"Dizzying Sand": {
		"name": "Dizzying Sand",
		"description": "Kind of dry, but it got into your eyes before. Harvested in the wilds",
		"tooltip":"Throw sand to blind the enemy",
		"use": "Lasts 1 turn, takes 6 turns to replenish"
	},
	"Bottle of Wind": {
		"name": "Bottle of Wind",
		"description": "It's unknown how the stars got this wind inside the bottle. The bottle is cold.",
		"tooltip":"Guaranteed to dodge for 2 turns.",
		"use": "Takes 9 turns to replenish."
	},
	"Box of spikes": {
		"name": "Box of spikes",
		"description": "Each spike were crafted carefully by the blacksmith. They all had names too? Oh dear.",
		"tooltip":"When the enemy attacks, they recieve 20% of the damage dealt.",
		"use": "Permanent until end of combat. One-time use"
	},
	"Glacior Smoke": {
		"name": "Glacior Smoke",
		"description": "You know it's cold. Then why is it hot? Icy hot?",
		"tooltip":"Inflicts freeze and burn on the target.",
		"use": "Freeze: 1 turn. Burn: Until death. One-time use."
	},
	"Cluster-Sharpener": {
		"name": "Cluster-Sharpener",
		"description":"What in the world were the inventors thinking when you could put a bomb on a stick!?",
		"tooltip": "Next 5 attacks have a 75% chance to explode and deal 1.5 x damage.",
		"use": "Lasts 5 turns. Takes 14 turns to replenish."
	},
	"Lightning Smite": {
		"name": "Lightning Smite",
		"description": "BY THE GODS MIGHT is the last thing heard by the one that weilded this... object.",
		"tooltip": "Smite the enemy through a lightning strike, stunning and damaging the enemy",
		"use": "Takes 17 turns to replenish."
	},
	"Refill": {
		"name": "Refill",
		"description" : "You take a sip from your trusty Staerie created can of water.",
		"tooltip" : "Heal between 40% - 60% of your health. Gain an attack boost for 5 turns",
		"use": "Takes 18 turns to refill."
	},	
	"Fish": {
		"name": "FIFISH",
		"description": "It always works. It always works. It always works.",
		"tooltip": "Summons a giant fish that heals the player for 80% of their health.",
		"use": "Takes 20 turns to replenish."
	},
	"Staerie smash": {
		"name": "Staerie smash",
		"description": "... Wait huh? You guys hear that? Oh dear god. HERE IT COMES! ",
		"tooltip": "Insta-kills non-boss enemies. Also grants a random wish: heal 50%, refresh all cooldowns, or guarantee dodge for 4 turns.",
		"use": "One-time use."
	}
}


func _ready() -> void:
	# Connect the global stats signal to update the UI automatically.
	GlobalPlayerStats.connect("stats_updated", Callable(self, "_change_number_values"))

	# Update the skill tool tips.
	# Connect each skill button’s mouse_entered and mouse_exited signals
	$StatContainer/CharSkills/GridContainer/PoisonBottle.connect("mouse_entered", Callable(self, "_on_skill_button_mouse_entered").bind("Poison Bottle"))
	$StatContainer/CharSkills/GridContainer/PoisonBottle.connect("mouse_exited", Callable(self, "_on_skill_button_mouse_exited"))

	$StatContainer/CharSkills/GridContainer/DizzyingSand.connect("mouse_entered", Callable(self, "_on_skill_button_mouse_entered").bind("Dizzying Sand"))
	$StatContainer/CharSkills/GridContainer/DizzyingSand.connect("mouse_exited", Callable(self, "_on_skill_button_mouse_exited"))

	$StatContainer/CharSkills/GridContainer/BottleOfWind.connect("mouse_entered", Callable(self, "_on_skill_button_mouse_entered").bind("Bottle of Wind"))
	$StatContainer/CharSkills/GridContainer/BottleOfWind.connect("mouse_exited", Callable(self, "_on_skill_button_mouse_exited"))

	$StatContainer/CharSkills/GridContainer/BoxOfSpikes.connect("mouse_entered", Callable(self, "_on_skill_button_mouse_entered").bind("Box of spikes"))
	$StatContainer/CharSkills/GridContainer/BoxOfSpikes.connect("mouse_exited", Callable(self, "_on_skill_button_mouse_exited"))

	$StatContainer/CharSkills/GridContainer/GlaciorSmoke.connect("mouse_entered", Callable(self, "_on_skill_button_mouse_entered").bind("Glacior Smoke"))
	$StatContainer/CharSkills/GridContainer/GlaciorSmoke.connect("mouse_exited", Callable(self, "_on_skill_button_mouse_exited"))

	$StatContainer/CharSkills/GridContainer/ClusterSharpener.connect("mouse_entered", Callable(self, "_on_skill_button_mouse_entered").bind("Cluster-Sharpener"))
	$StatContainer/CharSkills/GridContainer/ClusterSharpener.connect("mouse_exited", Callable(self, "_on_skill_button_mouse_exited"))

	$StatContainer/CharSkills/GridContainer/LightningSmite.connect("mouse_entered", Callable(self, "_on_skill_button_mouse_entered").bind("Lightning Smite"))
	$StatContainer/CharSkills/GridContainer/LightningSmite.connect("mouse_exited", Callable(self, "_on_skill_button_mouse_exited"))

	$StatContainer/CharSkills/GridContainer/Refill.connect("mouse_entered", Callable(self, "_on_skill_button_mouse_entered").bind("Refill"))
	$StatContainer/CharSkills/GridContainer/Refill.connect("mouse_exited", Callable(self, "_on_skill_button_mouse_exited"))

	$StatContainer/CharSkills/GridContainer/FISH.connect("mouse_entered", Callable(self, "_on_skill_button_mouse_entered").bind("Fish"))
	$StatContainer/CharSkills/GridContainer/FISH.connect("mouse_exited", Callable(self, "_on_skill_button_mouse_exited"))

	$StatContainer/CharSkills/GridContainer/StaerieSmash.connect("mouse_entered", Callable(self, "_on_skill_button_mouse_entered").bind("Staerie smash"))
	$StatContainer/CharSkills/GridContainer/StaerieSmash.connect("mouse_exited", Callable(self, "_on_skill_button_mouse_exited"))


	# Hide the tooltip panel at startup
	$SkillTooltipPanel.visible = false
	
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

func _on_skill_button_mouse_entered(skill_name: String) -> void:
	# Check if the skill name is in the dictionary
	if skill_data.has(skill_name):
		var info = skill_data[skill_name]
		# Build display text so each info stat appears on its own line:
		var display_text = "%s\n%s\n%s\n%s" % [
			info["name"],
			info["description"],
			info["tooltip"],
			info["use"]
		]
		$SkillTooltipPanel/TooltipLabel.text = display_text
		$SkillTooltipPanel.visible = true

func _on_skill_button_mouse_exited() -> void:
	$SkillTooltipPanel.visible = false