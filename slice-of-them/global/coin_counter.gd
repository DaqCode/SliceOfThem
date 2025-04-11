extends Control

func _process(_delta: float) -> void:
	$Panel/ActualBackground/Label.text = str(GlobalPlayerStats.coins)
