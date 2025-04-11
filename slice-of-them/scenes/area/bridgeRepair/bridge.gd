extends Control

var bridgeProgress = [
	preload("res://art/background/bridgeProgress/BridgeStage1.png"),
	preload("res://art/background/bridgeProgress/BridgeStage2.png"),
	preload("res://art/background/bridgeProgress/BridgeStage3.png"),
	preload("res://art/background/bridgeProgress/BridgeStage4.png"),    
	preload("res://art/background/bridgeProgress/BridgeStage5.png"),
	preload("res://art/background/bridgeProgress/BridgeStage6.png"),
	preload("res://art/background/bridgeProgress/BridgeStage7.png"),
	preload("res://art/background/bridgeProgress/BridgeStage8.png"),
	preload("res://art/background/bridgeProgress/BridgeStage9.png"),
	preload("res://art/background/bridgeProgress/BridgeCOMPLETE.png"),
]

@onready var staerieAnimation = $StaerieBob
@onready var staerieAnimationPlayer = $IdleBoy

@onready var bridgeUpgrade = $Upgrade
@onready var bridgeVisual = $BridgeProgress

var bridgeprogressCounter := 0


func _ready() -> void:
	staerieAnimationPlayer.play("StaerieIdle")
	get_tree().create_timer(randi_range(10, 20)).timeout.connect(self.on_timer_timeout)

	get_tree().create_timer(randi_range(30, 40)).timeout.connect(self.on_move_timer_timeout)

func on_timer_timeout() -> void:
	staerieAnimation.play("default")
	get_tree().create_timer(randi_range(10,20)).timeout.connect(self.on_timer_timeout)

func on_move_timer_timeout() -> void:
	staerieAnimationPlayer.play("ChangePosition")
	await get_tree().create_timer(15.5).timeout
	_ready() 

func _on_upgrade_pressed() -> void:
	# Cost formula
	var upgrade_cost = 5000 * (bridgeprogressCounter + 1) * (bridgeprogressCounter + 1)
	
	if GlobalPlayerStats.coins >= upgrade_cost:
		# Deduct cost
		$BridgeFixingAnimation.play("BridgeFix")
		await get_tree().create_timer(7.5).timeout

		print("Animation done, check the next thing.")
		GlobalPlayerStats.coins -= upgrade_cost  
		bridgeprogressCounter += 1
		if bridgeprogressCounter > 9:
			# Cap at final stage
			bridgeprogressCounter = 9  
		bridgeVisual.texture = bridgeProgress[bridgeprogressCounter]
		print("Bridge upgraded to stage", bridgeprogressCounter, "! Coins left:", GlobalPlayerStats.coins)

	else:
		print("Not enough coins! You need ", upgrade_cost, " coins to upgrade.")
