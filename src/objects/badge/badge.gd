extends Area2D

# --- SIGNALS ---


# --- CONFIGURATION & EXPORTS ---


# --- DATA & REFERENCES ---
var is_revealed: bool = false


# --- LIFECYCLE CALLBACKS ---
func _ready() -> void:
	# Tell GameManager how many badges exist in this level.
	GameManager.register_level_badge()
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


func _on_body_entered(body: Node2D) -> void:
	if not is_revealed:
		return

	if body.name == "Player" or body.is_in_group("player"):
		_trigger_level_victory()


func _trigger_level_victory() -> void:
	set_deferred("monitoring", false)
	GameManager.collect_badge()
	queue_free()
