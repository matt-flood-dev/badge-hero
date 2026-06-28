extends Area2D

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---
var is_revealed: bool = false


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
	monitoring = false
	body_entered.connect(_on_body_entered)
	GameManager.enemy_defeated.connect(_reveal_badge)


# --- INPUT HANDLING ---


# --- UPDATE LOOPS ---


# --- PUBLIC METHODS ---


# --- PRIVATE METHODS ---
func _reveal_badge() -> void:
	is_revealed = true
	visible = true
	monitoring = true


# Evaluates overlapping bodies to confirm player collision and trigger level victory
func _on_body_entered(body: Node2D) -> void:
	if not is_revealed:
		return

	if body.name == "Player" or body.is_in_group("player"):
		_trigger_level_victory()


# Locks down player movement or states and runs the final level completion sequences
func _trigger_level_victory() -> void:
	print("VICTORY! Level-Ending Badge collected successfully.")

	set_deferred("monitoring", false)

	print("Transitioning to the next staging zone...")

	queue_free()
