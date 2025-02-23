extends Node

# Base stats
@export var base_health: int = 10
@export var base_attack: int = 10
@export var defense: int = 0
@export var crit_stat: int = 0
@export var agility_stat: int = 0

# Derived stats (calculated via formulas)
var effective_health: float = base_health
var effective_attack: float = base_attack
var crit_chance: float = 2.5    # Starting at 2.5%
var dodge_chance: float = 1     # Starting at 1%
var crit_multiplier: float = 1.5# Starting at 2x Damage, which will scale as the player recieves more attack.
var block_chance: float = 10    # Starting at 10%
var block_amount_percent: float = 10    # Starting at 10%

func _ready():
	recalc_stats()

# Increase functions update the base stats and then recalc effective stats.
func increase_health(amount: int) -> void:
	base_health += amount
	recalc_stats()
	print("Your base health is now: %f" % base_health)	

func increase_attack(amount: int) -> void:
	base_attack += amount
	recalc_stats()
	print("Your attack power is now: %f" % base_attack)	

func increase_defense(amount: int) -> void:
	defense += amount
	recalc_stats()
	print("Your defense power is now: %f" % defense)	

func increase_crit(amount: float) -> void:
	crit_stat += amount
	recalc_stats()
	print("Your critical chance is now: %f%%" % crit_chance)
	print("Your critical multiplier is now: %f" % crit_multiplier)

func increase_agility(amount: float) -> void:
	agility_stat += amount
	recalc_stats()
	print("Your dodge chance is now: %f%%" % dodge_chance)



# Recalculate effective stats using the provided formulas
func recalc_stats() -> void:
	# Health: Total Health = base_health + (1.5 * defense) + ((defense/100)*0.05*Total Health)
	# Solve for Total Health (H):  H = (base_health + 1.5*defense) / (1 - 0.0005*defense)
	if defense < 2000:  # Ensure denominator stays positive
		effective_health = (base_health + 1.5 * defense) / (1 - 0.0005 * defense)
	else:
		effective_health = base_health + 1.5 * defense  # Fallback

	# Attack: For now, use base_attack. Later, add weapon multipliers.
	effective_attack = base_attack  # + (weapon_tier * 100) if applicable

	# Crit Chance: Crit Chance = 2.5 + (crit_stat * 5)%
	crit_chance = 2.5 + (crit_stat * 5)

	# Crit Multiplier: Starts at 1.5, increases by 0.1 per 200 crit_stat, capped at 2.5
	crit_multiplier = min(1.5 + 0.1 * (crit_stat / 200.0), 2.5)

	# Dodge Chance: Dodge Chance = 1 + (agility_stat / 10)%, capped at 50%
	dodge_chance = min(1 + (agility_stat / 10.0), 50)

	# Print stats for debugging
	print("Effective Health:", effective_health)
	print("Effective Attack:", effective_attack)
	print("Crit Chance:", crit_chance, "%")
	print("Crit Multiplier:", crit_multiplier)
	print("Dodge Chance:", dodge_chance, "%")

# Called when the player is attacked.
func take_damage(incoming_damage: float) -> void:
	var damage_after_defense = apply_defense(incoming_damage)
	# health -= damage_after_defense
	# print("Player took ", damage_after_defense, " damage. Remaining health: ", health)

func apply_defense(incoming_damage: float) -> float:
	var base_defense_chance = 5.0
	var defense_factor = 0.1  # Each defense point adds 0.1% chance.
	var defense_chance = base_defense_chance + defense * defense_factor
	defense_chance = clamp(defense_chance, 0, 90)
	
	if randf() * 100 < defense_chance:
		print("Defense activated! Damage reduced by 50%.")
		return incoming_damage * 0.5
	else:
		return incoming_damage