extends Area2D

# AI assistance: Portions of this script were drafted with Cursor AI and reviewed by the author.

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---
var is_unlocked: bool = false


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
	# Hidden until every gem is collected.
	monitoring = false
	body_entered.connect(_on_body_entered)
	GameManager.gem_collected.connect(_on_gem_collected)


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---


# --- PUBLIC METHODS ---


# --- PRIVATE METHODS ---
func _on_gem_collected(current_count: int, total_required: int) -> void:
	if current_count >= total_required:
		_reveal_key()


func _reveal_key() -> void:
	is_unlocked = true
	visible = true
	monitoring = true
	print("All objective gems gathered! The Yellow Key has materialised.")


func _on_body_entered(body: Node2D) -> void:
	if is_unlocked and (body.name == "Player" or body.is_in_group("player")):
		GameManager.obtain_key()
		queue_free()
