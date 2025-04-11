extends TextureRect

var target_scale := Vector2(0.45, 0.45)
var tween_active: bool = false

# Count of buttons currently hovered over.
var hovering_count: int = 0

# Timer node reference.
@onready var hide_timer: Timer = $HideTimer
@onready var potion_sprite: TextureRect = $PotionSample

# Preloaded textures for frame alternation (if needed)
var frame1_texture: Texture2D = preload("res://aniations/cloudSwitch/Frame1.png")
var frame2_texture: Texture2D = preload("res://aniations/cloudSwitch/Frame2.png")

var swap_timer: float = 0.0
var active_tween: Tween = null

func _ready() -> void:
	self.scale = Vector2(0,0)

func show_cloud(new_texture: Texture2D, new_title: String, new_desc: String) -> void:
	# Update the potion UI content.
	$PotionSample.texture = new_texture
	$PotionName.text = new_title
	$PotionDescription.text = new_desc

	if active_tween and active_tween.is_valid():
		self.scale = Vector2(0.4, 0.4)
		active_tween.kill()
		return

	# Increase hover count because a button is hovered.
	hovering_count += 1
	# Stop the hide timer if it's running.
	if hide_timer.is_stopped() == false:
		hide_timer.stop()
	
	# If the cloud is hidden (scale near zero), tween it in.

	if self.scale.x < 0.1 and not tween_active:
		tween_active = true
		active_tween = create_tween()

		active_tween.tween_property(self, "scale", target_scale, 0.45).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
		active_tween.connect("finished", Callable(self, "_on_tween_finished"))

		
func hide_cloud() -> void:
	if active_tween and active_tween.is_valid():
		self.scale = Vector2(0,0)
		active_tween.kill()

	tween_active = true
	active_tween = create_tween()
	active_tween.tween_property(self, "scale", Vector2.ZERO, 0.2).set_trans(Tween.TRANS_LINEAR)
	active_tween.connect("finished", Callable(self, "_on_tween_finished"))


func _on_tween_finished():
	tween_active = false

func _process(delta: float) -> void:
	if self.scale.x > 0.1:  # Only process if visible
		swap_timer += delta
		if swap_timer >= 0.5:
			swap_timer = 0.0
			# Swap between your two preloaded textures
			if self.texture == frame1_texture:
				self.texture = frame2_texture
			else:
				self.texture = frame1_texture
