extends Area2D

# AI assistance: Portions of this script were drafted with Cursor AI and reviewed by the author.

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
	body_entered.connect(_on_body_entered)


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---


# --- PUBLIC METHODS ---


# --- PRIVATE METHODS ---
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.is_in_group("player"):
		GameManager.collect_gem()
		queue_free()
