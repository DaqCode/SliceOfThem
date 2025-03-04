extends Node

signal skill_upgraded(skill_name: String, new_level: int)

# Dictionary holding the current upgrade level (0 to 5) for each skill.
var skills_upgrades = {
	"Poison Bottle": 0,
	"Dizzying Sand": 0,
	"Bottle of Wind": 0,
	"Box of spikes": 0,
	"Glacior Smoke": 0,
	"Cluster-Sharpener": 0,
	"Lightning Smite": 0,
	"Refill": 0,
	"Fish": 0,
	"Staerie smash": 0
}

# -------------------------------
# Poison Bottle variables
var poison_bottle_damage_percent = 2.0   # 2% damage per turn
var poison_bottle_duration = 3             # lasts 3 turns
var poison_bottle_replenish = 6            # takes 6 turns to replenish

# -------------------------------
# Dizzying Sand variables
var dizzying_sand_duration = 1             # lasts 1 turn initially
var dizzying_sand_damage_bonus = 25        # 25% more damage initially
var dizzying_sand_replenish = 6            # takes 6 turns to replenish

# -------------------------------
# Bottle of Wind variables
var bottle_of_wind_dodge_turns = 2          # dodge for 2 turns
var bottle_of_wind_replenish = 9            # takes 9 turns to replenish
var bottle_of_wind_stun_turns = 0           # initially no stun effect
var bottle_of_wind_damage_multiplier = 1.0  # initially 1x damage multiplier

# -------------------------------
# Box of spikes variables
var box_of_spikes_damage_recoil = 20       # enemy receives 20% of its damage
var box_of_spikes_poison_chance = 0          # no chance to inflict poison initially
var box_of_spikes_poison_damage = 0.0        # no poison damage initially

# -------------------------------
# Glacior Smoke variables
var glacior_smoke_freeze_multiplier = 150    # 150% freeze multiplier
var glacior_smoke_burn_percent = 10            # 10% burn damage

# -------------------------------
# Cluster-Sharpener variables
var cluster_sharpener_duration = 5         # lasts 5 turns
var cluster_sharpener_explode_chance = 75    # 75% chance to explode
var cluster_sharpener_damage_multiplier = 1.5  # 1.5x damage multiplier
var cluster_sharpener_replenish = 17         # takes 17 turns to replenish

# -------------------------------
# Lightning Smite variables
var lightning_smite_stun_turns = 2          # stuns for 2 turns initially
var lightning_smite_replenish = 17          # takes 17 turns to replenish
var lightning_smite_damage_base = 10000     # base damage is 10,000

# -------------------------------
# Refill variables
var refill_heal_range = Vector2(40, 60)       # heals between 40% and 60% of health

# -------------------------------
# Fish variables
var fish_heal_percent = 80                   # heals 80% of health
var fish_enemy_damage_factor = 0.0           # no enemy damage until upgrade 5

# -------------------------------
# Staerie smash variables
var staerie_smash_unlocked = false           # locked until upgraded
# -------------------------------

func upgrade_skill(skill_name: String) -> void:
    # Make sure the skill exists in our upgrade dictionary.
    if not skills_upgrades.has(skill_name):
        return
    var level = skills_upgrades[skill_name]
    if level >= 5:
        print(skill_name, "is already max upgraded!")
        return
    level += 1
    skills_upgrades[skill_name] = level
    print(skill_name, "upgraded to level ", level)
    
    match skill_name:
        "Poison Bottle":
            match level:
                1:
                    # Upgrade 1: 2% -> 3%
                    poison_bottle_damage_percent = 3.0
                2:
                    # Upgrade 2: 3% -> 4% and lasts 4 turns.
                    poison_bottle_damage_percent = 4.0
                    poison_bottle_duration = 4
                3:
                    # Upgrade 3: 4% -> 4.5%
                    poison_bottle_damage_percent = 4.5
                4:
                    # Upgrade 4: 4.5% -> 5%
                    poison_bottle_damage_percent = 5.0
                5:
                    # Upgrade 5: 5% -> 7.5%, lasts 5 turns, takes 5 turns to replenish.
                    poison_bottle_damage_percent = 7.5
                    poison_bottle_duration = 5
                    poison_bottle_replenish = 5
                    
        "Dizzying Sand":
            match level:
                1:
                    # Upgrade 1: Lasts 1 turn -> 2 turns.
                    dizzying_sand_duration = 2
                2:
                    # Upgrade 2: 25% more damage -> 35% more damage.
                    dizzying_sand_damage_bonus = 35
                3:
                    # Upgrade 3: 35% -> 40%.
                    dizzying_sand_damage_bonus = 40
                4:
                    # Upgrade 4: Lasts 2 turns -> 3 turns.
                    dizzying_sand_duration = 3
                5:
                    # Upgrade 5: Lasts 3 turns -> 4 turns, and 40% -> 50% damage.
                    dizzying_sand_duration = 4
                    dizzying_sand_damage_bonus = 50
                    
        "Bottle of Wind":
            match level:
                1:
                    # Upgrade 1: Dodge for 2 turns -> 3 turns.
                    bottle_of_wind_dodge_turns = 3
                2:
                    # Upgrade 2: Replenish from 9 turns -> 8 turns.
                    bottle_of_wind_replenish = 8
                3:
                    # Upgrade 3: Replenish from 8 turns -> 7 turns.
                    bottle_of_wind_replenish = 7
                4:
                    # Upgrade 4: Dodge for 3 turns -> 4 turns.
                    bottle_of_wind_dodge_turns = 4
                5:
                    # Upgrade 5: New buff—stuns enemy for 2 turns and deals 1.5× damage,
                    # and also dodge increases from 4 turns -> 5 turns; replenish from 7 turns -> 6 turns.
                    bottle_of_wind_dodge_turns = 5
                    bottle_of_wind_replenish = 6
                    bottle_of_wind_stun_turns = 2  # New effect (you can integrate this in combat logic)
                    bottle_of_wind_damage_multiplier = 1.5
                    
        "Box of spikes":
            match level:
                1:
                    # Upgrade 1: 20% -> 25% damage recoil.
                    box_of_spikes_damage_recoil = 25
                2:
                    # Upgrade 2: 25% -> 27.5% damage recoil.
                    box_of_spikes_damage_recoil = 27.5
                3:
                    # Upgrade 3: 27.5% -> 30% damage recoil.
                    box_of_spikes_damage_recoil = 30
                4:
                    # Upgrade 4: Adds chance to inflict poison.
                    # For example, 20% chance to poison, and poison deals 3.5% damage per turn.
                    box_of_spikes_poison_chance = 20
                    box_of_spikes_poison_damage = 3.5
                5:
                    # Upgrade 5: 30% -> 35% damage recoil.
                    box_of_spikes_damage_recoil = 35
                    
        "Glacior Smoke":
            match level:
                1:
                    # Upgrade 1: Freeze multiplier 150% -> 160%.
                    glacior_smoke_freeze_multiplier = 160
                2:
                    # Upgrade 2: Freeze multiplier 160% -> 170%.
                    glacior_smoke_freeze_multiplier = 170
                3:
                    # Upgrade 3: Burn: 10% -> 12.5%.
                    glacior_smoke_burn_percent = 12.5
                4:
                    # Upgrade 4: Freeze multiplier 170% -> 180%.
                    glacior_smoke_freeze_multiplier = 180
                5:
                    # Upgrade 5: Freeze multiplier 180% -> 200%, Burn: 12.5% -> 16%.
                    glacior_smoke_freeze_multiplier = 200
                    glacior_smoke_burn_percent = 16
                    
        "Cluster-Sharpener":
            match level:
                1:
                    # Upgrade 1: Duration from 5 turns -> 6 turns.
                    cluster_sharpener_duration = 6
                2:
                    # Upgrade 2: Explosion chance from 75% -> 80%.
                    cluster_sharpener_explode_chance = 80
                3:
                    # Upgrade 3: Damage multiplier from 1.5x -> 1.65x.
                    cluster_sharpener_damage_multiplier = 1.65
                4:
                    # Upgrade 4: Replenish time from 17 turns -> 15 turns.
                    cluster_sharpener_replenish = 15
                5:
                    # Upgrade 5: Duration from 6 turns -> 7 turns,
                    # Explosion chance from 80% -> 90%, damage multiplier from 1.65x -> 1.75x,
                    # and replenish time from 15 turns -> 13 turns.
                    cluster_sharpener_duration = 7
                    cluster_sharpener_explode_chance = 90
                    cluster_sharpener_damage_multiplier = 1.75
                    cluster_sharpener_replenish = 13
                    
        "Lightning Smite":
            match level:
                1:
                    # Upgrade 1: Stun for 2 turns -> 3 turns.
                    lightning_smite_stun_turns = 3
                2:
                    # Upgrade 2: Replenish from 17 turns -> 16 turns.
                    lightning_smite_replenish = 16
                3:
                    # Upgrade 3: Adjust base damage; for example, from 10000 damage to 1    5000 damage times a formula.
                    lightning_smite_damage_base = 15000
                4:
                    # Upgrade 4: Replenish from 16 turns -> 15 turns.
                    lightning_smite_replenish = 15
                5:
                    # Upgrade 5: Increase base damage from 15000 -> 20000 (or adjust formula accordingly)
                    # and stun duration from 3 turns -> 4 turns.
                    lightning_smite_damage_base = 20000
                    lightning_smite_stun_turns = 4
                    
        "Refill":
            match level:
                1:
                    refill_heal_range = Vector2(45, 60)
                2:
                    refill_heal_range = Vector2(50, 60)
                3:
                    refill_heal_range = Vector2(50, 70)
                4:
                    refill_heal_range = Vector2(55, 70)
                5:
                    refill_heal_range = Vector2(60, 70)
                    
        "Fish":
            match level:
                1, 2, 3, 4:
                    # No upgrade effect until level 5.
                    pass
                5:
                    # Upgrade 5: Heals 100% health and deals damage equal to half the enemy's max health.
                    fish_heal_percent = 100
                    fish_enemy_damage_factor = 0.5
                    
        "Staerie smash":
            # Only one upgrade needed to unlock this skill.
            if level == 1:
                staerie_smash_unlocked = true
    emit_signal("skill_upgraded", skill_name, level)
