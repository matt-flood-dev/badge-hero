extends Control

# AI assistance: Portions of this script were drafted with Cursor AI and reviewed by the author.

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---
@onready var full_heart: TextureRect = $FullHeart
@onready var empty_heart: TextureRect = $EmptyHeart


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
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
	# Guard against _ready order issues when the player updates hearts very early.
	if full_heart == null:
		full_heart = $FullHeart
		empty_heart = $EmptyHeart
