extends Node
class_name BaseSword

# Basic identification
@export var sword_name: String = ""

# Stat bonuses provided by the sword
@export var attack_bonus: int = 0    # e.g., Wood Sword: +50 Attack
@export var defense_bonus: int = 0   # Some swords add a bit of defense bonus.
@export var agility_bonus: int = 0   # Bonus to agility, if applicable.
@export var crit_bonus: int = 0      # Bonus to crit chance or stat.

# Special effects – for example, "lifesteal", "poison", "stun", "coin_boost"
@export var special_effect: String = ""
# A numerical value to help quantify the special effect.
@export var effect_value: float = 0

# Calculates damage when attacking.
# It starts with the sword's attack bonus, adds the player's base attack,
# and then applies a critical chance based on the sword's crit bonus.
func calculate_damage(player) -> int:
    var base_damage = attack_bonus
    # Incorporate the player's own attack value if available.
    if player.has_method("get_attack"):
        base_damage += player.get_attack()
    
    # Apply critical hit logic using the sword's crit bonus.
    # Here, we assume crit_bonus is a percentage value (e.g. 10 for 10% chance).
    if randf() < (crit_bonus / 100.0):
        base_damage *= 2  # Double damage on crit.
    
    return base_damage

# Attack function: Applies the calculated damage to a target.
# Also triggers any special effect after dealing damage.
func attack(target) -> void:
    if target.has_method("take_damage"):
        var damage_dealt = calculate_damage(get_parent())  # Assuming the sword is a child of the player.
        target.take_damage(damage_dealt)
        
        # Handle special effects:
        match special_effect:
            "lifesteal":
                # Example: if the target is killed, steal a percentage of its health.
                # (Actual lifesteal logic would be implemented here.)
                # For instance, if effect_value is 5, then 5% lifesteal.
                if target.has_method("is_dead") and target.is_dead():
                    if get_parent().has_method("heal"):
                        get_parent().heal(damage_dealt * (effect_value / 100.0))
            "poison":
                # Apply poison effect to the target for a number of turns.
                if target.has_method("apply_status"):
                    target.apply_status("poison", effect_value)
            "stun":
                # Stun the target with a certain chance.
                if randf() < (effect_value / 100.0):
                    if target.has_method("apply_status"):
                        target.apply_status("stun", 1)  # 1 turn stun.

            "coinboost":
                # Increase the player's coin count by a certain amount.
                if get_parent().has_method("add_coins"):
                    get_parent().add_coins(effect_value)

            _:
                # No special effect, or not recognized.
                pass
