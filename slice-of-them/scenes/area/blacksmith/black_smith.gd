extends Control

# Define base prices
var base_weapon_cost = 10
var base_cloud_cost = 10
var base_temp_cost = 10
var base_coin_cost = 100

# Define scaling factors
var weapon_scaling = 1.75
var cloud_scaling = 1.75
var skill_scaling = 1.75
var coin_scaling = 1.75

# Function to calculate item cost
func get_cost(base_price: float, scaling_factor: float, num_purchases: int) -> int:
    return int(base_price * pow(scaling_factor, num_purchases))

# Example usage
var weapon_cost = get_cost(base_weapon_cost, weapon_scaling, 5) # Cost of 6th weapon
var cloud_cost = get_cost(base_cloud_cost, cloud_scaling, 3) # Cost of 4th cloud

var coin_cost = get_cost(base_coin_cost, coin_scaling, 4) # Cost of 5th coin multiplier
