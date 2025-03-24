extends Node

signal stats_updated  # Signal to notify when stats are updated

# Base stats
@export var base_health: int = 10
@export var base_attack: int = 10
@export var defense: int = 0
@export var crit_stat: int = 0
@export var agility_stat: int = 0

@export var coins: int = 100000

# Derived stats (calculated via formulas)
var effective_health: float = base_health
var effective_attack: float = base_attack
var crit_chance: float = 2.5    # Starting at 2.5%
var dodge_chance: float = 1   # Starting at 1%
var crit_multiplier: float = 1.5  # Starting at 1.5x damage

# New defense/block variables
var block_chance: float = 10    # Base chance to block (in percent)
var block_amount_percent: float = 50  # Base amount of damage blocked (in percent)

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
	# Rearranged: effective_health = (base_health + 1.5 * defense) / (1 - 0.0005 * defense)
	if defense < 2000:
		effective_health = (base_health + 1.5 * defense) / (1 - 0.0005 * defense)
	else:
		effective_health = base_health + 1.5 * defense

	# Updated Block Chance & Block Amount using new scaling:
	# (These multipliers have been adjusted—you can tweak them as needed.)
	block_chance = clamp(10 + defense * 0.02964, 0, 90)
	block_amount_percent = clamp(50 + defense * 0.02643, 0, 90)

	# Attack: For now, use base_attack (later add weapon multipliers if applicable).
	effective_attack = base_attack
	
	# Crit Chance: Example formula (tweak as needed)
	crit_chance = 0.75 + (crit_stat * 0.096)
	
	# Crit Multiplier: Starts at 1.5, increases by 0.1 per 200 crit_stat, capped at 2.5
	crit_multiplier = min(1.5 + 0.1 * (crit_stat / 200.0), 2.5)
	
	# Dodge Chance: Example formula (tweak as needed)
	dodge_chance = min(0.136 + (agility_stat / 57.0), 50)

	# Debug prints
	print("----------------------------------------------------------------")
	print("Effective Health:", effective_health)
	print("Effective Attack:", effective_attack)
	print("Block Chance:", block_chance, "%")
	print("Block Amount:", block_amount_percent, "%")
	print("Dodge Chance:", dodge_chance, "%")
	print("Crit Chance:", crit_chance, "%")
	print("Crit Multiplier:", crit_multiplier, "x")



	# Emit the signal so that any UI listening can update
	emit_signal("stats_updated")

# Called when the player is attacked.
func take_damage(incoming_damage: float) -> void:
	var damage_after_defense = apply_defense(incoming_damage)
	print("Player took ", damage_after_defense, " damage.")

# Apply defense: Check if a block occurs, then reduce damage accordingly.
func apply_defense(incoming_damage: float) -> float:
	if randf() * 100 < block_chance:
		print("Block activated! Damage reduced by ", block_amount_percent, "%.")
		return incoming_damage * (1 - block_amount_percent / 100.0)
	else:
		return incoming_damage
