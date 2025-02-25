extends Node
class_name BaseCloud

# Basic identification
@export var cloud_name: String = ""

# Primary defensive bonus (this is the main stat for a shield)
@export var defense_bonus: int = 0

# Optional additional bonuses
@export var agility_bonus: int = 0    # Some clouds grant extra agility
@export var attack_bonus: int = 0     # Some clouds grant extra attack
@export var crit_bonus: int = 0       # Some clouds grant extra crit

# Special effect can modify behavior (e.g., "deflect")
@export var special_effect: String = ""  
# For example, if special_effect is "deflect", this value determines the recoil percent:
@export var deflect_recoil: float = 0.0  # e.g., 10.0 means enemy takes 10% of incoming damage

# Visual and descriptive properties (for UI)
@export var description: String = ""
@export var duration: float = 0.0   # If the cloud's effect is temporary
@export var cooldown: float = 0.0   # If the cloud can only be used periodically

# Function to apply the cloud's effect to a target (usually the player)
func apply_effect(target) -> void:
	# Increase the target's stats by the cloud's bonuses.
	target.increase_defense(defense_bonus)
	if agility_bonus != 0:
		target.increase_agility(agility_bonus)
	if attack_bonus != 0:
		target.increase_attack(attack_bonus)
	if crit_bonus != 0:
		target.increase_crit(crit_bonus)
	
	# Handle special effects.
	if special_effect == "deflect":
		# You might have a method on the target to set deflect mode.
		# For example, set_deflect_mode(active:bool, recoil:float)
		target.set_deflect_mode(true, deflect_recoil)
		# Alternatively, you could modify a variable directly.
