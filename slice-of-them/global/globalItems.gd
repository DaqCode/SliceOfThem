extends Node
class_name GameItem

@export var item_name: String
@export var description: String
@export var cost: int
@export var rarity: String
@export var item_type: String # Weapon, Defense, Skill, Coin, Temp Item
@export var effect: Dictionary

func apply_effect(player):
    # This function will be overridden in specific item scripts
    pass
