extends Node
class_name BaseSword

@export var sword_name: String 
@export var damage: int
@export var defense: int 		
@export var crit_chance: float 			 	# 10% critical chance for example
@export var special_effect: String = ""  	# "lifesteal", "burn", etc.

func calculate_damage(player) -> int:
    var final_damage = damage
    
    # Apply critical hit logic
    if randf() < crit_chance:
        final_damage *= 2  # Double damage on crit
    
    # Apply player's strength stat (if applicable)
    if player.has_method("get_strength"):
        final_damage += player.get_strength()
    
    return final_damage

# Attack function for swords
func attack(target):
    if target.has_method("take_damage"):
        var damage_dealt = calculate_damage(get_parent())  # Assuming the sword is a child of the player
        target.take_damage(damage_dealt)
