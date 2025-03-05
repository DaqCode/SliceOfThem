extends Control

@onready var stat_change := $StatContainer/CharStats/Indicator/WhatStatChange
@onready var stat_change_numerical := $StatContainer/CharNumStats/NumberStats

# Dictionary for the tooltips.
var skill_data = {
    "Poison Bottle": {
        "name": "Poison Bottle",
        "description": "The last one. That was made without any instructions.",
        "tooltip": "Deals 2.0% damage per turn.",
        "use": "Lasts 3 turns, takes 6 turns to replenish."
    },
    "Dizzying Sand": {
        "name": "Dizzying Sand",
        "description": "Kind of dry, but it got into your eyes before. Harvested in the wilds.",
        "tooltip": "Increases enemy damage taken by 25%.",
        "use": "Lasts 1 turn, takes 6 turns to replenish."
    },
    "Bottle of Wind": {
        "name": "Bottle of Wind",
        "description": "It's unknown how the stars got this wind inside the bottle. The bottle is cold.",
        "tooltip": "Guarantees dodge for 2 turns.",
        "use": "Takes 9 turns to replenish."
    },
    "Box of spikes": {
        "name": "Box of spikes",
        "description": "You want some of me? You're going to get some of you instead, buster!",
        "tooltip": "Enemy takes 20% of damage as recoil.",
        "use": "Permanent until end of combat. One-time use."
    },
    "Glacior Smoke": {
        "name": "Glacior Smoke",
        "description": "You know it's cold. Then why is it hot? Icy hot? Also, what's a glacior?",
        "tooltip": "Freeze multiplier: 150%, Burn: 5%.",
        "use": "Freeze: 1 turn. Burn: Until death. One-time use."
    },
    "Cluster-Sharpener": {
        "name": "Cluster-Sharpener",
        "description": "What in the world were the inventors thinking when you could put a bomb on a stick!?",
        "tooltip": "Next 5 attacks have 75% chance to explode for 1.5× damage.",
        "use": "Lasts 5 turns. Takes 14 turns to replenish."
    },
    "Lightning Smite": {
        "name": "Lightning Smite",
        "description": "BY THE GODS MIGHT is the last thing heard by the one who wielded this object.",
        "tooltip": "Deals 10000 base damage stunning for 2 turns.",
        "use": "Takes 17 turns to replenish."
    },
    "Refill": {
        "name": "Refill",
        "description": "You take a sip from your trusty Staerie-created can of water (or pudding).",
        "tooltip": "Heals between 40.0% and 60.0% of your health; grants an attack boost for 5 turns.",
		#Heals 40%-60% of your health; grants an attack boost for 5 turns.
        "use": "Takes 18 turns to refill."
    },
    "Fish": {
        "name": "Fish",
        "description": "It always works. It always works. It always works.",
        "tooltip": "Summons a giant fish that heals for 80% of your health.",
        "use": "Takes 20 turns to replenish."
    },
    "Staerie smash": {
        "name": "Staerie smash",
        "description": "… Wait, huh? You guys hear that? Oh dear god. HERE IT COMES!",
        "tooltip": "Instakills non-boss enemies and grants a random wish.",
        "use": "One-time use."
    }
}


func _ready() -> void:
	# Connect the global stats signal to update the UI automatically.
	GlobalPlayerStats.connect("stats_updated", Callable(self, "_change_number_values"))
	
	# Dictionary mapping the button node names to the skill names.
	var skills = {
		"PoisonBottle": "Poison Bottle",
		"DizzyingSand": "Dizzying Sand",
		"BottleOfWind": "Bottle of Wind",
		"BoxOfSpikes": "Box of spikes",
		"GlaciorSmoke": "Glacior Smoke",
		"ClusterSharpener": "Cluster-Sharpener",
		"LightningSmite": "Lightning Smite",
		"Refill": "Refill",
		"FISH": "Fish",
		"StaerieSmash": "Staerie smash"
	}
	
	# Get the GridContainer node.
	var grid_container = $StatContainer/CharSkills/GridContainer
	
	# Loop over each skill entry and connect signals.
	for node_name in skills.keys():
		var skill_name = skills[node_name]
		var btn = grid_container.get_node(node_name)
		if btn:
			# Connect mouse_entered and mouse_exited signals for tooltip display.
			# Connect the pressed signal for upgrading the skill.
			btn.connect("mouse_entered", Callable(self, "_on_skill_button_mouse_entered").bind(skill_name))
			btn.connect("mouse_exited", Callable(self, "_on_skill_button_mouse_exited"))
			btn.connect("pressed", Callable(self, "_on_skill_button_pressed").bind(skill_name))
	
	# Hide the tooltip panel at startup.
	$SkillTooltipPanel.visible = false
	# Initial update of the UI text.
	_change_number_values()


# -- UI for general stat upgrades (Health, Attack, etc.) --
func _on_health_pressed() -> void:
	GlobalPlayerStats.increase_health(14)
	_on_health_mouse_entered()

func _on_attack_pressed() -> void:
	GlobalPlayerStats.increase_attack(14)
	_on_attack_mouse_entered()

func _on_agility_pressed() -> void:
	GlobalPlayerStats.increase_agility(14)
	_on_agility_mouse_entered()

func _on_defense_pressed() -> void:
	GlobalPlayerStats.increase_defense(14)
	_on_defense_mouse_entered()

func _on_crit_pressed() -> void:
	GlobalPlayerStats.increase_crit(14)
	_on_crit_mouse_entered()

func _on_health_mouse_entered() -> void:
	stat_change.text = "Health: %s -> %s" % [GlobalPlayerStats.base_health, GlobalPlayerStats.base_health+14]

func _on_attack_mouse_entered() -> void:
	stat_change.text = "Attack: %s -> %s" % [GlobalPlayerStats.base_attack, GlobalPlayerStats.base_attack+14]

func _on_agility_mouse_entered() -> void:
	stat_change.text = "Agility: %s -> %s" % [GlobalPlayerStats.agility_stat, GlobalPlayerStats.agility_stat+14]

func _on_defense_mouse_entered() -> void:
	stat_change.text = "Defense: %s -> %s" % [GlobalPlayerStats.defense, GlobalPlayerStats.defense+14]

func _on_crit_mouse_entered() -> void:
	stat_change.text = "Crit: %s -> %s" % [GlobalPlayerStats.crit_stat, GlobalPlayerStats.crit_stat+14]

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

# -- Skill Tooltip Functions --

func _on_skill_button_mouse_entered(skill_name: String) -> void:
	# Show the tooltip for the skill.
	if skill_data.has(skill_name):
		var info = skill_data[skill_name]
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

# -- Skill Upgrade Function --
func _on_skill_button_pressed(skill_upgrade_name: String) -> void:
	# Upgrade the skill in the global script.
	GlobalPlayerSkills.upgrade_skill(skill_upgrade_name)
	
	# Update the base dictionary for this skill with the new upgrade values.
	if skill_data.has(skill_upgrade_name):
		var info = skill_data[skill_upgrade_name]
		match skill_upgrade_name:
			"Poison Bottle":
				info["tooltip"] = "Deals " + str(GlobalPlayerSkills.poison_bottle_damage_percent) + "% damage per turn."
				info["use"] = "Lasts " + str(GlobalPlayerSkills.poison_bottle_duration) + " turns, takes " + str(GlobalPlayerSkills.poison_bottle_replenish) + " turns to replenish."
			"Dizzying Sand":
				info["tooltip"] = "Increases enemy damage taken by " + str(GlobalPlayerSkills.dizzying_sand_damage_bonus) + "%."
				info["use"] = "Lasts " + str(GlobalPlayerSkills.dizzying_sand_duration) + " turn(s), takes " + str(GlobalPlayerSkills.dizzying_sand_replenish) + " turns to replenish."
			"Bottle of Wind":
				info["tooltip"] = "Guarantees dodge for " + str(GlobalPlayerSkills.bottle_of_wind_dodge_turns) + " turns."
				info["use"] = "Takes " + str(GlobalPlayerSkills.bottle_of_wind_replenish) + " turns to replenish."
			"Box of spikes":
				info["tooltip"] = "Enemy takes " + str(GlobalPlayerSkills.box_of_spikes_damage_recoil) + "% of damage as recoil."
				if GlobalPlayerSkills.box_of_spikes_poison_chance > 0:
					info["tooltip"] += " Has a " + str(GlobalPlayerSkills.box_of_spikes_poison_chance) + "% chance to poison (" + str(GlobalPlayerSkills.box_of_spikes_poison_damage) + "% damage per turn)."
				info["use"] = "Permanent until end of combat. One-time use."
			"Glacior Smoke":
				info["tooltip"] = "Freeze multiplier: " + str(GlobalPlayerSkills.glacior_smoke_freeze_multiplier) + "%, Burn: " + str(GlobalPlayerSkills.glacior_smoke_burn_percent) + "%."
				info["use"] = "Freeze: 1 turn. Burn: Until death. One-time use."
			"Cluster-Sharpener":
				info["tooltip"] = "Next 5 attacks have " + str(GlobalPlayerSkills.cluster_sharpener_explode_chance) + "% chance to explode for " + str(GlobalPlayerSkills.cluster_sharpener_damage_multiplier) + "× damage."
				info["use"] = "Lasts " + str(GlobalPlayerSkills.cluster_sharpener_duration) + " turns, takes " + str(GlobalPlayerSkills.cluster_sharpener_replenish) + " turns to replenish."
			"Lightning Smite":
				info["tooltip"] = "Deals " + str(GlobalPlayerSkills.lightning_smite_damage_base) + " base damage, stunning for " + str(GlobalPlayerSkills.lightning_smite_stun_turns) + " turn(s)."
				info["use"] = "Takes " + str(GlobalPlayerSkills.lightning_smite_replenish) + " turns to replenish."
			"Refill":
				info["tooltip"] = "Heals between " + str(GlobalPlayerSkills.refill_heal_range.x) + "% and " + str(GlobalPlayerSkills.refill_heal_range.y) + "% of your health; grants an attack boost for 5 turns."
				info["use"] = "Takes 18 turns to refill."
			"Fish":
				if GlobalPlayerSkills.skills_upgrades["Fish"] < 5:
					info["tooltip"] = "Summons a giant fish that heals for 80% of your health."
					info["use"] = "Takes 20 turns to replenish."
				else:
					info["tooltip"] = "Summons a giant fish that heals 100% of your health and deals damage equal to 50% of the enemy's max health."
					info["use"] = "Takes 20 turns to replenish."
			"Staerie smash":
				if GlobalPlayerSkills.skills_upgrades["Staerie smash"] >= 1:
					info["tooltip"] = "Instakills non-boss enemies and grants a random wish (heal 50%, refresh cooldowns, or guarantee dodge)."
					info["use"] = "Unlocked."
				else:
					info["tooltip"] = "Locked."
					info["use"] = ""
			_:
				# For skills with no extra logic, leave them unchanged.
				pass
		
		# Build the display text with each element on a new line.
		var display_text = "%s\n%s\n%s\n%s" % [
			info["name"],
			info["description"],
			info["tooltip"],
			info["use"]
		]
		$SkillTooltipPanel/TooltipLabel.text = display_text
		$SkillTooltipPanel.visible = true
	
	print("Upgraded skill: ", skill_upgrade_name)
