extends Control

@onready var ammo_icon = preload("res://icon.svg")  # Preload the ammo icon
@onready var ammo_container = $Panel/AmmoContainer  # Parent container for ammo slots
@onready var use_ammo_button = $UseAmmoButton  # Reference to the button

var ammo_count = 6  # Starting ammo count
var ammo_display = []  # Stores ammo slot references

signal ammo_used

func _ready() -> void:
	use_ammo_button.connect("pressed", Callable(self, "_use_ammo"))
	_update_ammo_display()

func _use_ammo() -> void:
	print("Yes, you clicked on it")
	if ammo_count > 0:
		ammo_count -= 1
		emit_signal("ammo_used")  # Signal that ammo waas used
		_update_ammo_display()
	else:
		print("Out of ammo! Reloading in 2 seconds...")
		await get_tree().create_timer(2).timeout  # Wait 2 seconds
		ammo_count = 6
		print("Ammo reloaded!")
		_reload_ammo_display()  # Gradually reload the ammo display

func _update_ammo_display() -> void:
	# Clear existing ammo slots
	for child in ammo_container.get_children():
		child.queue_free()
	
	# Create new ammo slots based on current count
	for i in range(ammo_count):
		var ammo_slot = TextureRect.new()
		ammo_slot.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		ammo_slot.expand_mode = TextureRect.EXPAND_FIT_HEIGHT
		ammo_slot.texture = ammo_icon
		ammo_container.add_child(ammo_slot)

func _reload_ammo_display() -> void:
	# Gradually reload the ammo slots with a delay
	for i in range(ammo_count):
		await get_tree().create_timer(0.1).timeout  # Wait 0.1 seconds before adding each bullet
		var ammo_slot = TextureRect.new()
		ammo_slot.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
		ammo_slot.expand_mode = TextureRect.EXPAND_FIT_HEIGHT
		ammo_slot.texture = ammo_icon
		ammo_container.add_child(ammo_slot)
