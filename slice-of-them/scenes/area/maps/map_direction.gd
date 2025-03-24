extends Control

var THEME_HOVER = preload("res://resources/Textures/UIPurpose/MapMenuThemeHover.tres")
var THEME_NORMAL = preload("res://resources/Textures/UIPurpose/MapMenuThemeNormal.tres")

func _ready() -> void:
	# Inventory
	$Player.connect("mouse_entered", Callable(self, "_on_InventoryButton_mouse_entered"))
	$Player.connect("mouse_exited", Callable(self, "_on_InventoryButton_mouse_exited"))
	$Player.connect("pressed", Callable(self, "_on_InventoryButton_clicked"))
	
	# Defend
	$Fight.connect("mouse_entered", Callable(self, "_on_DefendButton_mouse_entered"))
	$Fight.connect("mouse_exited", Callable(self, "_on_DefendButton_mouse_exited"))

	# Library
	$Credits.connect("mouse_entered", Callable(self, "_on_LibraryButton_mouse_entered"))
	$Credits.connect("mouse_exited", Callable(self, "_on_LibraryButton_mouse_exited"))
	$Credits.connect("pressed", Callable(self, "_on_LibraryButton_clicked"))

	# Blacksmith
	$Blacksmith.connect("mouse_entered", Callable(self, "_on_BlacksmithButton_mouse_entered"))
	$Blacksmith.connect("mouse_exited", Callable(self, "_on_BlacksmithButton_mouse_exited"))
	$Blacksmith.connect("pressed", Callable(self, "_on_BlacksmithButton_pressed"))

	# Training
	$Training.connect("mouse_entered", Callable(self, "_on_TrainingButton_mouse_entered"))
	$Training.connect("mouse_exited", Callable(self, "_on_TrainingButton_mouse_exited"))

	# Bridge
	$Bridge.connect("mouse_entered", Callable(self, "_on_BridgeButton_mouse_entered"))
	$Bridge.connect("mouse_exited", Callable(self, "_on_BridgeButton_mouse_exited"))
	$Bridge.connect("pressed", Callable(self, "_on_BridgeButton_clicked"))

# Inventory Button
func _on_InventoryButton_mouse_entered() -> void:
	$Player.theme = THEME_HOVER

func _on_InventoryButton_mouse_exited() -> void:
	$Player.theme = THEME_NORMAL

func _on_InventoryButton_clicked() -> void:
	get_tree().change_scene_to_file("res://scenes/UI/Stats/main_character_stats.tscn")


# Defend Button
func _on_DefendButton_mouse_entered() -> void:
	$Fight.theme = THEME_HOVER

func _on_DefendButton_mouse_exited() -> void:
	$Fight.theme = THEME_NORMAL


# Library Button
func _on_LibraryButton_mouse_entered() -> void:
	$Credits.theme = THEME_HOVER

func _on_LibraryButton_mouse_exited() -> void:
	$Credits.theme = THEME_NORMAL

func _on_LibraryButton_clicked() -> void:
	get_tree().change_scene_to_file("res://scenes/area/credits/son_heat.tscn")


# Blacksmith Button
func _on_BlacksmithButton_mouse_entered() -> void:
	$Blacksmith.theme = THEME_HOVER

func _on_BlacksmithButton_mouse_exited() -> void:
	$Blacksmith.theme = THEME_NORMAL

func _on_BlacksmithButton_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/area/blacksmith/black_smith.tscn")


# Training Button
func _on_TrainingButton_mouse_entered() -> void:
	$Training.theme = THEME_HOVER

func _on_TrainingButton_mouse_exited() -> void:
	$Training.theme = THEME_NORMAL


# Bridge Button
func _on_BridgeButton_mouse_entered() -> void:
	$Bridge.theme = THEME_HOVER

func _on_BridgeButton_mouse_exited() -> void:
	$Bridge.theme = THEME_NORMAL

func _on_BridgeButton_clicked() -> void:
	get_tree().change_scene_to_file("res://scenes/area/bridgeRepair/bridge.tscn")