
extends Control

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---
@onready var full_heart: TextureRect = $FullHeart
@onready var empty_heart: TextureRect = $EmptyHeart


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
	# Default to showing a healthy, full container
	set_filled(true)


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---


# --- PUBLIC METHODS ---
func set_filled(is_filled: bool) -> void:
	_ensure_nodes()
	if is_filled:
		full_heart.visible = true
		empty_heart.visible = false
	else:
		full_heart.visible = false
		empty_heart.visible = true


# --- PRIVATE METHODS ---
func _ensure_nodes() -> void:
	if full_heart == null:
		full_heart = $FullHeart
		empty_heart = $EmptyHeart